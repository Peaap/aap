-- Stage 2 Engine: headless route and quest state only.
-- Dependency direction: AAP.Engine -> AAP.Data; presentation modules are deferred.

AAP = AAP or {}
AAP.Engine = AAP.Engine or {}
AAP.Engine.Dependencies = AAP.Engine.Dependencies or {
	Data = "AAP.Data",
}
AAP.Engine.RouteResolver = AAP.Engine.RouteResolver or {}
AAP.Engine.QuestState = AAP.Engine.QuestState or {}
AAP.Engine.RouteProgression = AAP.Engine.RouteProgression or {}
AAP.Engine.Navigation = AAP.Engine.Navigation or {}
AAP.Engine.Travel = AAP.Engine.Travel or {}

local RouteResolver = AAP.Engine.RouteResolver
local QuestState = AAP.Engine.QuestState
local RouteProgression = AAP.Engine.RouteProgression
local Navigation = AAP.Engine.Navigation
local Travel = AAP.Engine.Travel

local function questApiMethod(api, name)
	if (api and type(api[name]) == "function") then
		return function(...)
			return api[name](api, ...)
		end
	end
	if (type(_G) == "table" and type(_G[name]) == "function") then
		return _G[name]
	end
	return nil
end

local function questCompleted(value)
	return value == true or value == 1
end

-- Convert the quest log into headless route-predicate state.  Objective indexes
-- intentionally remain one-based, matching the legacy Qpart/QpartPart schema.
function QuestState:Scan(api)
	local snapshot = {
		active = {},
		completed = {},
		objectives = {},
	}
	local getCount = questApiMethod(api, "GetNumQuestLogEntries")
	local getTitle = questApiMethod(api, "GetQuestLogTitle")
	local getObjectiveCount = questApiMethod(api, "GetNumQuestLeaderBoards")
	local getObjective = questApiMethod(api, "GetQuestLogLeaderBoard")
	local isCompleted = questApiMethod(api, "IsQuestFlaggedCompleted")

	if (not getCount or not getTitle) then
		return snapshot
	end

	local entries = getCount() or 0
	for questIndex = 1, entries do
		local _, _, _, isHeader, _, isComplete, _, questId = getTitle(questIndex)
		if (not isHeader and type(questId) == "number" and questId > 0) then
			snapshot.active[questId] = true
			if (questCompleted(isComplete) or (isCompleted and isCompleted(questId) == true)) then
				snapshot.completed[questId] = true
			end
			snapshot.objectives[questId] = {}
			if (getObjectiveCount and getObjective) then
				local objectiveCount = getObjectiveCount(questIndex) or 0
				for objectiveIndex = 1, objectiveCount do
					local text, _, finished = getObjective(objectiveIndex, questIndex)
					snapshot.objectives[questId][objectiveIndex] = {
						questId = questId,
						index = objectiveIndex,
						text = text or "",
						completed = questCompleted(finished),
					}
				end
			end
		end
	end
	return snapshot
end

function QuestState:Refresh(api)
	self.Snapshot = self:Scan(api)
	return self.Snapshot
end

function QuestState:Accept(questId)
	self.Snapshot = self.Snapshot or { active = {}, completed = {}, objectives = {} }
	if (type(questId) == "number" and questId > 0) then
		self.Snapshot.active[questId] = true
		self.Snapshot.objectives[questId] = self.Snapshot.objectives[questId] or {}
	end
	return self.Snapshot
end

function QuestState:Remove(questId)
	self.Snapshot = self.Snapshot or { active = {}, completed = {}, objectives = {} }
	if (type(questId) == "number" and questId > 0) then
		self.Snapshot.active[questId] = nil
		self.Snapshot.objectives[questId] = nil
	end
	return self.Snapshot
end

local function contains(values, value)
	for _, candidate in ipairs(values) do
		if (candidate == value) then
			return true
		end
	end
	return false
end

local function completed(context, quests, questId)
	if (type(context.isQuestCompleted) == "function") then
		return context.isQuestCompleted(questId) == true
	end
	return quests and quests.completed and quests.completed[questId] == true
end

local function active(quests, questId)
	return quests and quests.active and quests.active[questId] == true
end

local function routeFor(data, routeKey)
	if (not data or not routeKey) then
		return nil
	end
	if (type(data.RouteFor) == "function") then
		return data:RouteFor(routeKey)
	end
	if (type(data.routeFor) == "function") then
		return data:routeFor(routeKey)
	end
	return nil
end

local function firstNumber(value)
	if type(value) == "number" then return value end
	if type(value) == "table" then
		for _, item in ipairs(value) do
			if type(item) == "number" then return item end
		end
	end
	return nil
end

local function stepKind(step)
	if type(step) ~= "table" then return nil end
	for _, key in ipairs({ "PickUp", "PickUp2", "Qpart", "QpartPart", "Done", "DropQuest", "CRange", "Range", "Trigger", "TT", "GetFP", "UseFlightPath", "SetHS", "UseHS", "UseDalaHS", "UseGarrisonHS", "Treasure", "ZonePick", "ZoneChoice", "ZoneDone", "GroupTask", "Group", "Optional", "QaskPopup" }) do
		if step[key] ~= nil then return key end
	end
	return "Route step"
end

local function collectStepQuestIds(step)
	local ids = {}
	local seen = {}
	if type(step) ~= "table" then return ids end
	local function collect(value)
		if type(value) == "number" then
			if not seen[value] then seen[value] = true; ids[#ids + 1] = value end
		elseif type(value) == "table" then
			for _, item in ipairs(value) do collect(item) end
			for key, item in pairs(value) do
				if type(key) ~= "number" then collect(item) end
			end
		end
	end
	for _, key in ipairs({ "PickUp", "PickUp2", "Qpart", "QpartPart", "Done", "DropQuest", "CRange", "GetFP", "UseFlightPath", "SetHS", "UseHS", "UseDalaHS", "UseGarrisonHS", "Treasure", "ZoneDone", "GroupTask", "Group", "Optional", "QaskPopup" }) do
		collect(step[key])
	end
	table.sort(ids)
	return ids
end

local function presentationStep(route, stepIndex)
	local step = type(route) == "table" and route[stepIndex] or nil
	if type(step) ~= "table" then return nil end
	return {
		kind = stepKind(step),
		questIds = collectStepQuestIds(step),
		name = type(step.Name) == "string" and step.Name or nil,
	}
end

local function coordinates(value)
	if (type(value) ~= "table" or type(value.x) ~= "number" or type(value.y) ~= "number") then
		return nil
	end
	return { x = value.x, y = value.y }
end

local function inactiveNavigation()
	return {
		active = false,
		target = nil,
		trigger = nil,
		range = nil,
		cRange = nil,
		segments = {},
	}
end

-- Produce a detached navigation snapshot from the legacy route schema. The
-- snapshot retains only coordinate/range inputs and never exposes route tables
-- for mutation by a future presentation adapter.
function Navigation:For(state, route)
	if (not state or not state.active or type(state.stepIndex) ~= "number" or type(route) ~= "table") then
		return inactiveNavigation()
	end

	local step = route[state.stepIndex]
	if (type(step) ~= "table") then
		return inactiveNavigation()
	end

	local target = coordinates(step.TT)
	local trigger = coordinates(step.Trigger)
	local range = type(step.Range) == "number" and step.Range or nil
	local cRange = step.CRange
	local snapshot = {
		active = target ~= nil or trigger ~= nil or range ~= nil,
		target = target,
		trigger = trigger,
		range = range,
		cRange = cRange,
		segments = {},
	}

	if (cRange and target) then
		snapshot.segments[1] = coordinates(step.TT)
		local nextStep = route[state.stepIndex + 1]
		if (type(nextStep) == "table" and coordinates(nextStep.TT)) then
			snapshot.segments[2] = coordinates(nextStep.TT)
			local followingStep = route[state.stepIndex + 2]
			if (nextStep.CRange and type(followingStep) == "table" and coordinates(followingStep.TT)) then
				snapshot.segments[3] = coordinates(followingStep.TT)
			end
		end
	end
	return snapshot
end

local function rounded(value)
	return math.floor(value + 0.5)
end

-- Locate the legacy-compatible reachable taxi node by its cached destination
-- coordinates. This is a selection decision only; no gameplay action occurs.
function Travel:TaxiNodeFor(nodes, destination)
	if (type(nodes) ~= "table" or not coordinates(destination)) then
		return nil
	end
	local destinationX = rounded(destination.x)
	local destinationY = rounded(destination.y)
	for index, node in ipairs(nodes) do
		if (node and (node.reachable == true or node.type == "REACHABLE")
			and type(node.x) == "number" and type(node.y) == "number"
			and rounded(node.x) == destinationX and rounded(node.y) == destinationY) then
			return node.index or index
		end
	end
	return nil
end

function Travel:For(state, context, route)
	local inactive = { active = false, kind = nil, destination = nil, eta = nil, skipIfOnTaxi = false, onTaxi = false, decision = nil, taxiNode = nil }
	if (not state or not state.active or type(state.stepIndex) ~= "number" or type(route) ~= "table") then
		return inactive
	end

	local step = route[state.stepIndex]
	if (type(step) ~= "table") then
		return inactive
	end
	context = context or {}
	if (step.GetFP) then
		return {
			active = true,
			kind = "flight-point",
			destination = step.Name,
			eta = nil,
			skipIfOnTaxi = false,
			onTaxi = context.onTaxi == true or context.onTaxi == 1,
			decision = "acquire-flight-point",
			taxiNode = nil,
		}
	end
	if (not step.UseFlightPath) then
		return inactive
	end

	local onTaxi = context.onTaxi == true or context.onTaxi == 1
	local destination = context.flightPoints and coordinates(context.flightPoints[step.Name])
	local taxiNode = self:TaxiNodeFor(context.taxiNodes, destination)
	local skipIfOnTaxi = step.SkipIfOnTaxi == true or step.SkipIfOnTaxi == 1
	local decision = "awaiting-taxi"
	if (skipIfOnTaxi and onTaxi) then
		decision = "advance"
	elseif (taxiNode) then
		decision = "select-taxi-node"
	end
	return {
		active = true,
		kind = step.Boat and "boat" or "flight-path",
		destination = step.Name,
		eta = step.ETA,
		skipIfOnTaxi = skipIfOnTaxi,
		onTaxi = onTaxi,
		decision = decision,
		taxiNode = taxiNode,
	}
end

local function characterSave(context)
	if (type(context.characterData) == "table") then
		return context.characterData
	end
	if (type(AAP1) == "table" and context.realm and context.name and type(AAP1[context.realm]) == "table") then
		return AAP1[context.realm][context.name]
	end
	return nil
end

local function legionEnabled(context)
	if (context.legionEnabled == true) then
		return true
	end
	local saved = characterSave(context)
	return saved and saved.Settings and saved.Settings.Legion == 1
end

local function factionMap(context)
	local mapId = context.mapId
	if (context.faction == "Alliance" and mapId ~= nil) then
		return "A" .. tostring(mapId)
	end
	return mapId
end

-- Select a route key with the same precedence as the legacy map updater: faction
-- prefix first, then gender/class start areas, followed by level-gated expansion
-- selectors and quest-specific overrides.
function RouteResolver:SelectRouteKey(context, quests)
	context = context or {}
	quests = quests or {}
	local mapId = factionMap(context)
	local rawMapId = context.mapId
	local level = context.level or 0

	if (rawMapId == 204) then
		if (context.gender == 2) then
			mapId = "194-male"
		elseif (context.gender == 3) then
			mapId = "194-female"
		end
	end

	if (context.classId == 6) then
		if (mapId == 23 and not completed(context, quests, 13189)) then
			mapId = "DK23-H"
		elseif (mapId == "A23" and not completed(context, quests, 13188)) then
			mapId = "DK23-A"
		end
	end

	if (context.classId == 12 and not completed(context, quests, 39689) and contains({ 630, 631, 632, 633, 672, 673, 674, 675 }, rawMapId)) then
		mapId = "A672-DH-Start"
	end

	if (context.faction == "Horde" and level == 20 and rawMapId == 321) then
		local alliedRaceRoutes = {
			MagharOrc = "1-MagharOrc",
			HighmountainTauren = "1-HighmountainTauren",
			Nightborne = "1-Nightborne",
		}
		mapId = alliedRaceRoutes[context.race] or mapId
	elseif (context.faction == "Alliance" and level == 20 and mapId == "A830" and context.race == "LightforgedDraenei") then
		mapId = "A830-20"
	end

	if (active(quests, 26320) and (rawMapId == 291 or rawMapId == 292)) then
		return "ADeadmines"
	end

	local legionAllowed = legionEnabled(context) or (level > 97 and level < 113)
	if (legionAllowed) then
		local suffix = context.faction == "Alliance" and "A" or ""
		if (context.faction == "Alliance" or context.faction == "Horde") then
			if ((rawMapId == 20 and level > 99 and level < 111)) then
				mapId = suffix .. "18-100-110"
			elseif ((rawMapId == 321 and level > 99 and level < 111)) then
				mapId = suffix .. "1-100to110"
			elseif (contains({ 625, 626, 627, 628, 629 }, rawMapId) and level > 99 and level < 111) then
				mapId = suffix .. "627-100-110"
			elseif (contains({ 634, 635, 636, 637, 638, 639, 640 }, rawMapId)) then
				mapId = suffix .. "634-100-110"
			elseif (contains({ 630, 631, 632, 633 }, rawMapId)) then
				mapId = suffix .. "630-100-110"
			elseif (contains({ 641, 642, 643, 644 }, rawMapId)) then
				mapId = suffix .. "641-100-110"
			elseif (rawMapId == 181) then
				mapId = suffix .. "76-100-110"
			elseif (contains({ 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660 }, rawMapId)) then
				mapId = suffix .. "650-100-110"
			end
		end
	end

	return mapId
end

function RouteResolver:NormalizeStep(route, savedStep)
	if (type(route) ~= "table" or type(savedStep) ~= "number" or savedStep < 1 or savedStep % 1 ~= 0 or route[savedStep] == nil) then
		return 1
	end
	return savedStep
end

function RouteResolver:Resolve(context, quests, state, data)
	context = context or {}
	state = state or {}
	local routeKey = self:SelectRouteKey(context, quests)
	local route = routeFor(data, routeKey)
	if (not route) then
		local inactiveState = {
			initialized = state.initialized == true,
			active = false,
			routeKey = nil,
			stepIndex = nil,
		}
		inactiveState.navigation = Navigation:For(inactiveState, nil)
		inactiveState.travel = Travel:For(inactiveState, context, nil)
		return inactiveState
	end

	local saved = characterSave(context)
	local stepIndex = self:NormalizeStep(route, saved and saved[routeKey])
	if (saved) then
		saved[routeKey] = stepIndex
	end
	local resolvedState = {
		initialized = state.initialized == true,
		active = true,
		routeKey = routeKey,
		stepIndex = stepIndex,
		step = presentationStep(route, stepIndex),
	}
	resolvedState.navigation = Navigation:For(resolvedState, route)
	resolvedState.travel = Travel:For(resolvedState, context, route)
	return resolvedState
end

function AAP.Engine:Initialize(context, data)
	if (self.Initialized) then
		return self.State
	end

	self.Initialized = true
	self.PlayerContext = context
	self.Data = data
	local quests = QuestState.Snapshot or { active = {}, completed = {}, objectives = {} }
	self.State = RouteResolver:Resolve(context, quests, { initialized = true }, data)
	self.State.quests = quests
	return self.State
end

function AAP.Engine:ResolveRoute(context, quests)
	self.PlayerContext = context or self.PlayerContext or {}
	quests = quests or QuestState.Snapshot or { active = {}, completed = {}, objectives = {} }
	self.State = RouteResolver:Resolve(self.PlayerContext, quests, self.State, self.Data)
	self.State.quests = quests
	return self.State
end

-- These event-facing helpers own quest-log state only.  Route progression is
-- deliberately deferred to RouteProgression so no presentation logic leaks in.
function AAP.Engine:RefreshQuestState(api)
	local snapshot = QuestState:Refresh(api)
	return self:ResolveRoute(self.PlayerContext, snapshot)
end

function AAP.Engine:QuestAccepted(questId)
	local snapshot = QuestState:Accept(questId)
	return self:ResolveRoute(self.PlayerContext, snapshot)
end

function AAP.Engine:QuestRemoved(questId)
	local snapshot = QuestState:Remove(questId)
	return self:ResolveRoute(self.PlayerContext, snapshot)
end

-- Route progression evaluates passive legacy step metadata against observed
-- engine state. It deliberately accepts only state inputs; no UI or gameplay
-- action is invoked from these predicates.
local function truthy(value)
	return value == true or value == 1
end

local function valueSatisfied(value, context, quests)
	if (type(value) == "table") then
		for _, questId in ipairs(value) do
			if (not valueSatisfied(questId, context, quests)) then
				return false
			end
		end
		return #value > 0
	end
	return type(value) == "number" and completed(context, quests, value)
end

local function skipped(context, questId)
	return (context.breadcrumbSkips and truthy(context.breadcrumbSkips[questId]))
		or (context.bonusSkips and truthy(context.bonusSkips[questId]))
end

local function objectivesSatisfied(requirements, context, quests, partial)
	local total = 0
	for questId, objectiveIndexes in pairs(requirements or {}) do
		for objectiveIndex in pairs(objectiveIndexes) do
			total = total + 1
			local objective = quests and quests.objectives and quests.objectives[questId]
				and quests.objectives[questId][tonumber(objectiveIndex) or objectiveIndex]
			if (not (completed(context, quests, questId) or skipped(context, questId)
				or (objective and objective.completed == true))) then
				if (partial and context.triggerText and objective and type(objective.text) == "string"
					and string.find(objective.text, context.triggerText, 1, true)) then
					return true
				end
				return false
			end
		end
	end
	return total > 0
end

local function rangeSatisfied(step, context)
	if (type(context.isStepInRange) == "function") then
		return context.isStepInRange(step) == true
	end
	return truthy(context.triggerReached) or truthy(context.inRange)
end

local function pickupSatisfied(questIds, context, quests)
	if (type(questIds) ~= "table" or #questIds == 0) then
		return false
	end
	for _, questId in ipairs(questIds) do
		if (not (active(quests, questId) or completed(context, quests, questId) or skipped(context, questId))) then
			return false
		end
	end
	return true
end

-- Returns whether a legacy step is complete. The predicates retain the legacy
-- schema names so passive route tables require no conversion.
function RouteProgression:StepSatisfied(step, context, quests)
	step = step or {}
	context = context or {}
	quests = quests or {}

	if (step.PickUp) then
		return pickupSatisfied(step.PickUp, context, quests) or pickupSatisfied(step.PickUp2, context, quests)
	elseif (step.Qpart) then
		return objectivesSatisfied(step.Qpart, context, quests, false)
	elseif (step.QpartPart) then
		return objectivesSatisfied(step.QpartPart, context, quests, true)
	elseif (step.Done) then
		return valueSatisfied(step.Done, context, quests)
	elseif (step.DropQuest) then
		return valueSatisfied(step.DropQuest, context, quests) or active(quests, step.DropQuest)
	elseif (step.CRange) then
		return valueSatisfied(step.CRange, context, quests) or skipped(context, step.CRange)
	elseif (step.Range or step.Trigger or step.TT) then
		return rangeSatisfied(step, context)
	elseif (step.GetFP) then
		return valueSatisfied(step.GetFP, context, quests) or (context.flightPoints and truthy(context.flightPoints[step.Name]))
	elseif (step.UseFlightPath) then
		return valueSatisfied(step.UseFlightPath, context, quests)
			or (truthy(step.SkipIfOnTaxi) and truthy(context.onTaxi))
			or (context.flightPaths and truthy(context.flightPaths[step.Name]))
	elseif (step.SetHS or step.UseHS or step.UseDalaHS or step.UseGarrisonHS) then
		local hearthQuest = step.SetHS or step.UseHS or step.UseDalaHS or step.UseGarrisonHS
		return valueSatisfied(hearthQuest, context, quests) or truthy(context.hearthstoneUsed)
	elseif (step.Treasure) then
		return valueSatisfied(step.Treasure, context, quests)
	elseif (step.ZonePick or step.ZoneChoice) then
		local choice = step.ZonePick or step.ZoneChoice
		return truthy(context.zoneChoiceMade) or (choice ~= true and context.selectedZone == choice)
	elseif (step.ZoneDone) then
		return valueSatisfied(step.ZoneDone, context, quests) or truthy(context.zoneCompleted)
	elseif (step.GroupTask or step.Group or step.Optional or step.QaskPopup) then
		local optionalQuest = step.GroupTask or step.Optional or step.QaskPopup
		return valueSatisfied(optionalQuest, context, quests)
			or (context.optionalSkipped and truthy(context.optionalSkipped[optionalQuest]))
	end
	return false
end

-- Advance exactly one step only when its successor exists. Persisting the
-- successor before recomputing ensures saves never contain an invalid index.
function RouteProgression:AdvanceIfSatisfied(state, context, data)
	state = state or {}
	context = context or AAP.Engine.PlayerContext or {}
	local route = routeFor(data or AAP.Engine.Data, state.routeKey)
	if (not state.active or not route or type(state.stepIndex) ~= "number") then
		return state
	end

	local step = route[state.stepIndex]
	local nextStep = route[state.stepIndex + 1]
	if (not step or not nextStep or not self:StepSatisfied(step, context, state.quests)) then
		return state
	end

	local save = characterSave(context)
	if (save) then
		save[state.routeKey] = state.stepIndex + 1
	end
	local nextIndex = state.stepIndex + 1
	local nextState = {
		initialized = state.initialized == true,
		active = true,
		routeKey = state.routeKey,
		stepIndex = nextIndex,
		step = presentationStep(route, nextIndex),
		quests = state.quests,
	}
	nextState.navigation = Navigation:For(nextState, route)
	nextState.travel = Travel:For(nextState, context, route)
	return nextState
end

function AAP.Engine:AdvanceIfSatisfied(context)
	self.PlayerContext = context or self.PlayerContext or {}
	self.State = RouteProgression:AdvanceIfSatisfied(self.State, self.PlayerContext, self.Data)
	return self.State
end

-- Quest events refresh the snapshot and immediately reevaluate the active step.
function AAP.Engine:RefreshQuestState(api)
	local snapshot = QuestState:Refresh(api)
	self:ResolveRoute(self.PlayerContext, snapshot)
	return self:AdvanceIfSatisfied(self.PlayerContext)
end

function AAP.Engine:QuestAccepted(questId)
	local snapshot = QuestState:Accept(questId)
	self:ResolveRoute(self.PlayerContext, snapshot)
	return self:AdvanceIfSatisfied(self.PlayerContext)
end

function AAP.Engine:QuestRemoved(questId)
	local snapshot = QuestState:Remove(questId)
	self:ResolveRoute(self.PlayerContext, snapshot)
	return self:AdvanceIfSatisfied(self.PlayerContext)
end

-- Runtime inputs are translated into a closed set of engine events. The queue
-- deliberately accepts data-only event records, never callbacks or presentation
-- jobs, so deferred legacy UI cannot enter the active Stage 2 work path.
local LEGACY_EVENT_KINDS = {
	PLAYER_LOGIN = "player-ready",
	PLAYER_ENTERING_WORLD = "player-ready",
	ZONE_CHANGED = "zone-changed",
	ZONE_CHANGED_NEW_AREA = "zone-changed",
	ZONE_CHANGED_INDOORS = "zone-changed",
	QUEST_LOG_UPDATE = "quest-log-changed",
	QUEST_ACCEPTED = "quest-accepted",
	QUEST_REMOVED = "quest-removed",
	PLAYER_CONTROL_GAINED = "travel-state-changed",
	PLAYER_CONTROL_LOST = "travel-state-changed",
	TAXIMAP_OPENED = "travel-state-changed",
	TAXIMAP_CLOSED = "travel-state-changed",
}

function AAP.Engine:QueueLegacyEvent(event, ...)
	if (not self.Initialized) then
		return false
	end

	local kind = LEGACY_EVENT_KINDS[event]
	if (not kind) then
		return false
	end

	self.PendingEvents = self.PendingEvents or {}
	table.insert(self.PendingEvents, {
		kind = kind,
		questId = (kind == "quest-accepted" or kind == "quest-removed") and ... or nil,
	})
	return true
end

function AAP.Engine:ProcessPendingEvents()
	if (not self.Initialized) then
		return self.State
	end

	self.PendingEvents = self.PendingEvents or {}
	while (#self.PendingEvents > 0) do
		local event = table.remove(self.PendingEvents, 1)
		if (event.kind == "player-ready" or event.kind == "zone-changed") then
			self:ResolveRoute(self.PlayerContext)
			self:AdvanceIfSatisfied(self.PlayerContext)
		elseif (event.kind == "quest-log-changed") then
			self:RefreshQuestState()
		elseif (event.kind == "quest-accepted") then
			self:QuestAccepted(event.questId)
		elseif (event.kind == "quest-removed") then
			self:QuestRemoved(event.questId)
		elseif (event.kind == "travel-state-changed") then
			self:AdvanceIfSatisfied(self.PlayerContext)
		end
	end
	return self.State
end
