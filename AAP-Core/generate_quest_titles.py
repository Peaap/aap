"""Generate AAP's English route-quest title table from the supplied Legion 7.3.5 data dump.

Input:  ElvUI/.quest-source/world/LegionCore_world_2020_04_25.sql
Output: AAP-Core/QuestTitles.lua
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
ROUTE_DIRECTORIES = (
    "AAP-Vanilla",
    "AAP-TBC-WotLK",
    "AAP-Cata-MoP",
    "AAP-WoD",
    "AAP-Legion",
)
SQL_DUMP = ROOT / "ElvUI" / ".quest-source" / "world" / "LegionCore_world_2020_04_25.sql"
OUTPUT = Path(__file__).resolve().parent / "QuestTitles.lua"


def balanced_table(text, start):
    depth = 0
    for index in range(start, len(text)):
        character = text[index]
        if character == "{":
            depth += 1
        elif character == "}":
            depth -= 1
            if depth == 0:
                return text[start:index + 1]
    raise ValueError("Unclosed Lua table")


def collect_route_quest_ids():
    ids = set()
    list_fields = ("PickUp", "PickUp2", "Done", "Done2")
    table_fields = ("Qpart", "QpartPart")

    for directory in ROUTE_DIRECTORIES:
        for route_file in (ROOT / directory).glob("*.lua"):
            content = route_file.read_text(encoding="utf-8")
            for field in list_fields:
                marker = '["{}"] = {{'.format(field)
                position = 0
                while True:
                    position = content.find(marker, position)
                    if position == -1:
                        break
                    table = balanced_table(content, content.find("{", position))
                    ids.update(int(value) for value in re.findall(r"\b(\d+)\s*,", table))
                    position += len(marker)
            for field in table_fields:
                marker = '["{}"] = {{'.format(field)
                position = 0
                while True:
                    position = content.find(marker, position)
                    if position == -1:
                        break
                    table = balanced_table(content, content.find("{", position))
                    ids.update(int(value) for value in re.findall(r"\[(\d+)\]\s*=", table))
                    position += len(marker)
            ids.update(int(value) for value in re.findall(r'\["QaskPopup"\]\s*=\s*(\d+)', content))
    return ids


def decode_sql(value):
    return value.replace("\\'", "'").replace("\\\\", "\\")


def collect_titles(wanted_ids):
    titles = {}
    row = re.compile(r"^\((\d+),'enUS','((?:\\.|[^'])*)',")
    with SQL_DUMP.open(encoding="utf-8", errors="replace") as dump:
        for line in dump:
            match = row.match(line)
            if not match:
                continue
            quest_id = int(match.group(1))
            if quest_id in wanted_ids:
                title = decode_sql(match.group(2))
                if title:
                    titles[quest_id] = title
    return titles


def lua_string(value):
    return value.replace("\\", "\\\\").replace('"', '\\"')


def main():
    quest_ids = collect_route_quest_ids()
    titles = collect_titles(quest_ids)
    missing = sorted(quest_ids - titles.keys())

    lines = [
        "-- Generated from ElvUI/.quest-source/world/LegionCore_world_2020_04_25.sql",
        "-- Source locale: enUS; source core build: Legion 7.3.5 (26972).",
        "AAP.QuestTitles = {",
    ]
    lines.extend('    [{}] = "{}",'.format(quest_id, lua_string(titles[quest_id])) for quest_id in sorted(titles))
    lines.append("}")
    lines.append("")
    OUTPUT.write_text("\n".join(lines), encoding="utf-8")

    print("Collected {} route quest IDs; generated {} titles; {} missing.".format(
        len(quest_ids), len(titles), len(missing)))
    if missing:
        print("Missing IDs: {}".format(", ".join(str(quest_id) for quest_id in missing)))


if __name__ == "__main__":
    main()
