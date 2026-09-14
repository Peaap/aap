-- Stage 2 Data: passive route and metadata registration only.
-- AAP.Data has no runtime, lifecycle, engine, or presentation dependencies.

AAP = AAP or {}
AAP.Data = AAP.Data or {}
AAP.Data.Dependencies = AAP.Data.Dependencies or {}

-- Dataset domains own static definitions only.  Preserve a pre-Stage 3 route
-- registry when present, then retain RouteRegistry as an alias for callers
-- that still use the legacy registry name.
AAP.Data.Quests = AAP.Data.Quests or {}
AAP.Data.QuestTitles = AAP.Data.QuestTitles or {}
AAP.Data.Zones = AAP.Data.Zones or {}
AAP.Data.NPCs = AAP.Data.NPCs or {}
AAP.Data.Routes = AAP.Data.Routes or AAP.Data.RouteRegistry or {}
AAP.Data.RouteRegistry = AAP.Data.Routes

local function registerEntries(registry, entries, entryIsValid)
	if (type(entries) ~= "table") then
		return 0
	end

	local registered = 0
	for key, entry in pairs(entries) do
		if (not entryIsValid or entryIsValid(entry)) then
			-- Store the original key and value directly. Registration owns only
			-- the domain mapping; it never rewrites a static definition.
			registry[key] = entry
			registered = registered + 1
		end
	end
	return registered
end

function AAP.Data:RegisterQuests(quests)
	return registerEntries(self.Quests, quests)
end

function AAP.Data:RegisterQuestTitles(questTitles)
	return registerEntries(self.QuestTitles, questTitles)
end

function AAP.Data:RegisterZones(zones)
	return registerEntries(self.Zones, zones)
end

function AAP.Data:RegisterNPCs(npcs)
	return registerEntries(self.NPCs, npcs)
end

function AAP.Data:RegisterRoutes(routes)
	return registerEntries(self.Routes, routes, function(steps)
		return type(steps) == "table"
	end)
end

function AAP.Data:RegisterLegacyRouteTables(...)
	local registered = 0
	for index = 1, select("#", ...) do
		registered = registered + self:RegisterRoutes(select(index, ...))
	end
	return registered
end

function AAP.Data:RegisterAvailableLegacyRoutes()
	-- Core-zone and expansion route providers historically merge these tables
	-- into AAP.QuestStepList. Temporary tables are also accepted so providers
	-- can register before performing that legacy merge.
	return self:RegisterLegacyRouteTables(
		AAP.QuestStepList,
		AAP.QuestStepListBoth,
		AAP.QuestStepList2060,
		AAP.QuestStepList2062
	)
end

function AAP.Data:QuestFor(questId)
	return self.Quests[questId]
end

function AAP.Data:QuestTitleFor(questId)
	return self.QuestTitles[questId]
end

function AAP.Data:ZoneFor(zoneKey)
	return self.Zones[zoneKey]
end

function AAP.Data:NPCFor(npcId)
	return self.NPCs[npcId]
end

function AAP.Data:RouteFor(routeKey)
	return self.Routes[routeKey]
end

-- Match the DataApi naming used by the engine design while preserving the
-- existing Lua-style method name for direct addon callers.
AAP.Data.routeFor = AAP.Data.RouteFor
