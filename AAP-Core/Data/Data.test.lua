-- Focused Lua 5.1 validation for the Stage 2 passive AAP.Data registry.
-- Run with: lua Data.test.lua from this directory.

local function serialize(value, seen)
	if (type(value) ~= "table") then
		return type(value) .. ":" .. tostring(value)
	end

	seen = seen or {}
	if (seen[value]) then
		return "<cycle>"
	end
	seen[value] = true

	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(left, right)
		return tostring(left) < tostring(right)
	end)

	local parts = { "{" }
	for _, key in ipairs(keys) do
		parts[#parts + 1] = serialize(key, seen) .. "=" .. serialize(value[key], seen) .. ";"
	end
	parts[#parts + 1] = "}"
	seen[value] = nil
	return table.concat(parts)
end

AAP = {
	QuestStepList = {
		["A84-100-110"] = {
			{ PickUp = { 42782 }, TT = { x = 1080, y = -8494.7 } },
		},
	},
	QuestStepListBoth = {
		["DK23-A"] = {
			{ Done = { 12593 }, Trigger = { x = -5618.9, y = 2413.1 }, Range = 16.93 },
		},
	},
	QuestStepList2060 = {
		["18-100-110"] = {
			{ Qpart = { [42782] = { ["1"] = "1" } } },
		},
	},
}

local coreRoutes = AAP.QuestStepList
local sharedRoutes = AAP.QuestStepListBoth
local legionRoutes = AAP.QuestStepList2060
local before = serialize({ coreRoutes, sharedRoutes, legionRoutes })

dofile("Data.lua")

assert(AAP.Data:RegisterAvailableLegacyRoutes() == 3, "all legacy route maps should register")
assert(AAP.Data:RouteFor("A84-100-110") == coreRoutes["A84-100-110"], "core route identity must be preserved")
assert(AAP.Data:RouteFor("DK23-A") == sharedRoutes["DK23-A"], "shared core-zone route identity must be preserved")
assert(AAP.Data:RouteFor("18-100-110") == legionRoutes["18-100-110"], "Legion route identity must be preserved")
assert(AAP.Data:RouteFor("missing-route") == nil, "missing routes must remain absent")
assert(AAP.Data:RegisterRoutes(nil) == 0, "invalid route sources must be ignored")
assert(serialize({ coreRoutes, sharedRoutes, legionRoutes }) == before, "registration and lookup must not mutate route definitions")

print("AAP.Data passive registry tests passed")
