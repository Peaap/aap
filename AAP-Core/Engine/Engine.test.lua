-- Focused Lua 5.1 validation for the Stage 2 headless route resolver.
-- Run with: lua Engine.test.lua from this directory.

AAP = {}
dofile("Engine.lua")

local routes = {
	["A630-100-110"] = { {}, {}, {} },
	["DK23-A"] = { {}, {} },
	["194-male"] = { {} },
	["1-MagharOrc"] = { {} },
	["ADeadmines"] = { {} },
}
local data = {
	RouteFor = function(_, key)
		return routes[key]
	end,
}

local function context(overrides)
	local value = {
		name = "Tester",
		realm = "Realm",
		faction = "Alliance",
		level = 100,
		mapId = 630,
		classId = 1,
		gender = 2,
		characterData = { Settings = {} },
	}
	for key, override in pairs(overrides or {}) do
		value[key] = override
	end
	return value
end

local resolver = AAP.Engine.RouteResolver

assert(resolver:SelectRouteKey(context(), {}) == "A630-100-110", "Alliance Legion maps should use the faction-prefixed Legion route")
assert(resolver:SelectRouteKey(context({ mapId = 23, classId = 6 }), { completed = {} }) == "DK23-A", "Death Knight class and incomplete quest should override the faction map")
assert(resolver:SelectRouteKey(context({ faction = "Horde", level = 20, mapId = 321, race = "MagharOrc" }), {}) == "1-MagharOrc", "allied-race selector should precede the generic route")
assert(resolver:SelectRouteKey(context({ faction = "Horde", level = 30, mapId = 204, gender = 2 }), {}) == "194-male", "gender route should override the raw map key")
assert(resolver:SelectRouteKey(context({ mapId = 291 }), { active = { [26320] = true } }) == "ADeadmines", "active Deadmines quest should override the zone route")

local missing = context()
local normalized = resolver:Resolve(missing, {}, { initialized = true }, data)
assert(normalized.active and normalized.stepIndex == 1, "missing saved progress should normalize to step one")
assert(missing.characterData["A630-100-110"] == 1, "normalization must persist the first valid step")

local invalid = context({ characterData = { ["A630-100-110"] = 4, Settings = {} } })
normalized = resolver:Resolve(invalid, {}, { initialized = true }, data)
assert(normalized.stepIndex == 1 and invalid.characterData["A630-100-110"] == 1, "out-of-range saved progress should normalize and persist")

local selected = context({ mapId = 999 })
local inactive = resolver:Resolve(selected, {}, { initialized = true }, data)
assert(not inactive.active and inactive.routeKey == nil and inactive.stepIndex == nil, "unregistered route keys should expose an inactive state")

-- **Validates: Requirements 3.2, 8.1**
-- Property: every missing, non-integral, out-of-range, or valid saved index is
-- normalized to step one or an existing route step and persisted unchanged otherwise.
for savedStep = -2, 6 do
	local propertyContext = context({ characterData = { ["A630-100-110"] = savedStep, Settings = {} } })
	local result = resolver:Resolve(propertyContext, {}, { initialized = true }, data)
	assert(result.stepIndex == 1 or routes[result.routeKey][result.stepIndex] ~= nil, "resolved step must always identify a route step")
	if (savedStep >= 1 and savedStep <= 3) then
		assert(result.stepIndex == savedStep, "valid persisted indices must be retained")
	else
		assert(result.stepIndex == 1, "invalid persisted indices must normalize to one")
	end
end

print("AAP.Engine route resolver tests passed")

local questApi = {
	entries = {
		{ title = "A quest", complete = false, questId = 101, objectives = { { "Collect two items: 1/2", false }, { "Return to NPC", true } } },
		{ title = "Complete quest", complete = true, questId = 202, objectives = {} },
	},
}
function questApi:GetNumQuestLogEntries()
	return #self.entries
end
function questApi:GetQuestLogTitle(index)
	local entry = self.entries[index]
	return entry.title, 0, 0, false, false, entry.complete, 0, entry.questId
end
function questApi:GetNumQuestLeaderBoards(index)
	return #self.entries[index].objectives
end
function questApi:GetQuestLogLeaderBoard(objectiveIndex, questIndex)
	local objective = self.entries[questIndex].objectives[objectiveIndex]
	return objective[1], "monster", objective[2]
end
function questApi:IsQuestFlaggedCompleted(questId)
	return questId == 303
end

local questState = AAP.Engine.QuestState
local snapshot = questState:Scan(questApi)
assert(snapshot.active[101] and snapshot.active[202], "quest-log scan must retain active quest IDs")
assert(snapshot.completed[202], "completed quest-log entries must be retained")
assert(snapshot.objectives[101][1].text == "Collect two items: 1/2", "objective text must be retained")
assert(not snapshot.objectives[101][1].completed and snapshot.objectives[101][2].completed, "objective completion must be retained per one-based objective index")
assert(not snapshot.completed[101], "incomplete quests must not be marked completed")

questState:Refresh(questApi)
questState:Accept(303)
assert(questState.Snapshot.active[303] and questState.Snapshot.objectives[303] ~= nil, "acceptance must add headless active-quest state")
questState:Remove(101)
assert(not questState.Snapshot.active[101] and questState.Snapshot.objectives[101] == nil, "removal must clear active quest and objectives")

-- **Validates: Requirements 4.1, 4.3, 8.1, 8.5**
-- Property: every scanned objective keeps its quest ID, one-based index, text,
-- and completion bit without consulting presentation globals.
for objectiveCount = 0, 4 do
	local generatedApi = {
		entries = { { title = "Generated", complete = false, questId = 500 + objectiveCount, objectives = {} } },
	}
	for index = 1, objectiveCount do
		generatedApi.entries[1].objectives[index] = { "Objective " .. index, index % 2 == 0 }
	end
	function generatedApi:GetNumQuestLogEntries() return #self.entries end
	function generatedApi:GetQuestLogTitle(index)
		local entry = self.entries[index]
		return entry.title, 0, 0, false, false, entry.complete, 0, entry.questId
	end
	function generatedApi:GetNumQuestLeaderBoards(index) return #self.entries[index].objectives end
	function generatedApi:GetQuestLogLeaderBoard(objectiveIndex, questIndex)
		local objective = self.entries[questIndex].objectives[objectiveIndex]
		return objective[1], "monster", objective[2]
	end
	local generated = questState:Scan(generatedApi)
	local questId = 500 + objectiveCount
	assert(generated.active[questId], "scanned quest must remain active")
	for index = 1, objectiveCount do
		local objective = generated.objectives[questId][index]
		assert(objective.questId == questId and objective.index == index, "objective identity must remain stable")
		assert(objective.text == "Objective " .. index and objective.completed == (index % 2 == 0), "objective state must remain stable")
	end
end

print("AAP.Engine quest state tests passed")


-- Task 6: headless route progression predicates and valid-only persistence.
local progression = AAP.Engine.RouteProgression
local progressionContext = context({ characterData = { Settings = {} } })
local completedQuests = {
	active = { [101] = true },
	completed = { [102] = true, [103] = true, [104] = true, [105] = true, [106] = true, [107] = true },
	objectives = {
		[101] = { [1] = { questId = 101, index = 1, text = "Collect", completed = true } },
	},
}

assert(progression:StepSatisfied({ PickUp = { 101 } }, progressionContext, completedQuests), "pickup steps should complete after their quests are accepted")
assert(progression:StepSatisfied({ Qpart = { [101] = { ["1"] = "1" } } }, progressionContext, completedQuests), "objective steps should complete after all required objectives")
assert(progression:StepSatisfied({ Done = { 102 } }, progressionContext, completedQuests), "hand-in steps should complete after turn-in")
assert(progression:StepSatisfied({ Trigger = { x = 1, y = 1 }, Range = 10 }, context({ triggerReached = true }), completedQuests), "travel/range steps should complete at their trigger")
assert(progression:StepSatisfied({ GetFP = 103 }, progressionContext, completedQuests), "flight-point steps should use their completion quest")
assert(progression:StepSatisfied({ UseFlightPath = 104 }, progressionContext, completedQuests), "flight-path steps should use their completion quest")
assert(progression:StepSatisfied({ UseHS = 105 }, progressionContext, completedQuests), "hearthstone steps should use their completion quest")
assert(progression:StepSatisfied({ Optional = 106 }, progressionContext, completedQuests), "optional/group steps should complete after their decision quest")
assert(progression:StepSatisfied({ Treasure = 107 }, progressionContext, completedQuests), "treasure steps should complete after their treasure quest")
assert(progression:StepSatisfied({ ZonePick = "Azsuna" }, context({ selectedZone = "Azsuna" }), completedQuests), "zone choice steps should complete after a matching choice")
assert(progression:StepSatisfied({ ZoneDone = 102 }, progressionContext, completedQuests), "zone completion steps should use their completion quest")

local progressionRoutes = {
	progression = {
		{ PickUp = { 101 } },
		{ Done = { 102 } },
	},
}
local progressionData = { RouteFor = function(_, key) return progressionRoutes[key] end }
local progressionState = { active = true, routeKey = "progression", stepIndex = 1, quests = completedQuests }
local advanced = progression:AdvanceIfSatisfied(progressionState, progressionContext, progressionData)
assert(advanced.stepIndex == 2 and progressionContext.characterData.progression == 2, "a satisfied step must persist and recompute its valid successor")
advanced = progression:AdvanceIfSatisfied(advanced, progressionContext, progressionData)
assert(advanced.stepIndex == 2 and progressionContext.characterData.progression == 2, "a final satisfied step must not persist a missing successor")

-- **Validates: Requirements 3.3, 3.4, 4.3, 8.1, 8.5**
-- Property: progression persists a successor only for a satisfied step and only
-- when that successor exists, independently of all legacy presentation globals.
for objectiveComplete = 0, 1 do
	local generatedQuests = {
		active = { [800] = true },
		completed = {},
		objectives = { [800] = { [1] = { completed = objectiveComplete == 1 } } },
	}
	local generatedContext = context({ characterData = { Settings = {} } })
	local generatedState = { active = true, routeKey = "progression", stepIndex = 1, quests = generatedQuests }
	progressionRoutes.progression[1] = { Qpart = { [800] = { ["1"] = "1" } } }
	local result = progression:AdvanceIfSatisfied(generatedState, generatedContext, progressionData)
	if (objectiveComplete == 1) then
		assert(result.stepIndex == 2 and generatedContext.characterData.progression == 2, "satisfied generated objective must advance to an existing step")
	else
		assert(result.stepIndex == 1 and generatedContext.characterData.progression == nil, "unsatisfied generated objective must not persist progress")
	end
end

print("AAP.Engine route progression tests passed")

-- Task 7: headless navigation and travel state for a later presentation adapter.
local navigation = AAP.Engine.Navigation
local travel = AAP.Engine.Travel
local navigationRoute = {
	{
		TT = { x = 12.5, y = 34.5 },
		Trigger = { x = 13.5, y = 35.5 },
		Range = 15,
		CRange = 9001,
	},
	{ TT = { x = 14.5, y = 36.5 }, CRange = 9002 },
	{ TT = { x = 15.5, y = 37.5 } },
}
local navigationState = navigation:For({ active = true, stepIndex = 1 }, navigationRoute)
assert(navigationState.active, "steps with navigation fields must publish active navigation state")
assert(navigationState.target.x == 12.5 and navigationState.target.y == 34.5, "target coordinates must be copied from TT")
assert(navigationState.trigger.x == 13.5 and navigationState.trigger.y == 35.5 and navigationState.range == 15, "trigger coordinates and range must be published")
assert(navigationState.cRange == 9001 and #navigationState.segments == 3, "continuous range steps must publish the compatible coordinate segments")
navigationState.target.x = 0
assert(navigationRoute[1].TT.x == 12.5, "navigation snapshots must not expose mutable route coordinate tables")

local travelRoute = {
	{
		UseFlightPath = 7001,
		Name = "Destination",
		ETA = 42,
		SkipIfOnTaxi = true,
	},
}
local travelContext = {
	flightPoints = { Destination = { x = 10.1, y = 20.1 } },
	taxiNodes = {
		{ index = 3, reachable = false, x = 10.1, y = 20.1 },
		{ index = 4, reachable = true, x = 10.4, y = 20.4 },
	},
}
local travelState = travel:For({ active = true, stepIndex = 1 }, travelContext, travelRoute)
assert(travelState.active and travelState.kind == "flight-path", "flight path steps must publish active travel state")
assert(travelState.destination == "Destination" and travelState.eta == 42, "travel state must retain destination and ETA metadata")
assert(travelState.taxiNode == 4 and travelState.decision == "select-taxi-node", "reachable matching taxi nodes must produce a selection decision")
travelContext.onTaxi = true
travelState = travel:For({ active = true, stepIndex = 1 }, travelContext, travelRoute)
assert(travelState.decision == "advance", "SkipIfOnTaxi must publish the legacy-compatible advancement decision")
local flightPointState = travel:For({ active = true, stepIndex = 1 }, {}, { { GetFP = 7002, Name = "New Point" } })
assert(flightPointState.kind == "flight-point" and flightPointState.decision == "acquire-flight-point", "flight point steps must publish acquisition state")

-- **Validates: Requirements 5.1-5.4, 6.1-6.4**
-- Property: navigation and taxi selection derive only detached engine state from
-- passive route metadata and supplied gameplay observations, with no UI globals.
for range = 1, 3 do
	local generatedRoute = { { TT = { x = range, y = range + 1 }, Range = range } }
	local generated = navigation:For({ active = true, stepIndex = 1 }, generatedRoute)
	assert(generated.active and generated.range == range, "generated navigation inputs must remain available headlessly")
	generated.target.x = -1
	assert(generatedRoute[1].TT.x == range, "generated navigation state must remain detached from route definitions")
end

print("AAP.Engine navigation and travel state tests passed")

-- Task 8: legacy runtime events are translated to engine-only pending work.
AAP.Engine.Initialized = false
AAP.Engine.State = nil
AAP.Engine.PlayerContext = nil
AAP.Engine.Data = nil
AAP.Engine.PendingEvents = nil

local dispatchRoutes = {
	["A630-100-110"] = {
		{ PickUp = { 901 } },
		{},
	},
}
local dispatchData = { RouteFor = function(_, key) return dispatchRoutes[key] end }
local dispatchContext = context({ characterData = { Settings = {} } })

assert(not AAP.Engine:QueueLegacyEvent("QUEST_ACCEPTED", 901), "events must not queue before engine initialization")
AAP.Engine:Initialize(dispatchContext, dispatchData)

local expectedKinds = {
	PLAYER_ENTERING_WORLD = "player-ready",
	ZONE_CHANGED_NEW_AREA = "zone-changed",
	QUEST_LOG_UPDATE = "quest-log-changed",
	QUEST_ACCEPTED = "quest-accepted",
	QUEST_REMOVED = "quest-removed",
	TAXIMAP_OPENED = "travel-state-changed",
}
for legacyEvent, expectedKind in pairs(expectedKinds) do
	assert(AAP.Engine:QueueLegacyEvent(legacyEvent, 901), "recognized legacy event must queue after initialization")
	local queued = AAP.Engine.PendingEvents[#AAP.Engine.PendingEvents]
	assert(queued.kind == expectedKind, "legacy input must map to its engine event kind")
	assert(type(queued) == "table" and type(queued.callback) == "nil", "engine queue records must not contain presentation callbacks")
	AAP.Engine:ProcessPendingEvents()
end

assert(AAP.Engine:QueueLegacyEvent("QUEST_ACCEPTED", 901), "quest acceptance must be accepted by the engine queue")
AAP.Engine:ProcessPendingEvents()
assert(AAP.Engine.State.stepIndex == 2 and dispatchContext.characterData["A630-100-110"] == 2, "queued quest events must update headless route state")
assert(not AAP.Engine:QueueLegacyEvent("RENDER_QUEST_LIST"), "presentation work must not enter the engine queue")
assert(not AAP.Engine:QueueLegacyEvent("CREATE_SECURE_MACRO_BUTTON"), "macro presentation work must not enter the engine queue")
assert(#AAP.Engine.PendingEvents == 0, "rejected presentation work must leave the engine queue unchanged")

-- **Validates: Requirements 1.2-1.3, 6.2-6.4, 7.3-7.5**
-- Property: every recognized legacy input queues a closed engine event record,
-- while unrecognized presentation work cannot be queued or invoke UI callbacks.
print("AAP.Engine event dispatch tests passed")