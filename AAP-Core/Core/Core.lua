-- Stage 2 Core: lifecycle readiness, player context, and engine coordination only.
-- Dependency direction: AAP.Core -> AAP.Engine -> AAP.Data.

AAP = AAP or {}
AAP.Core = AAP.Core or {}
AAP.Core.Dependencies = AAP.Core.Dependencies or {
	Engine = "AAP.Engine",
}

local function ensureTable(parent, key)
	if (type(parent[key]) ~= "table") then
		parent[key] = {}
	end
	return parent[key]
end

function AAP.Core:EnsureCharacterSavedData()
	if (type(AAP1) ~= "table" or not AAP.Name or not AAP.Realm) then
		return nil
	end

	local realmData = ensureTable(AAP1, AAP.Realm)
	local characterData = ensureTable(realmData, AAP.Name)
	ensureTable(characterData, "BonusSkips")
	ensureTable(characterData, "QlineSkip")
	ensureTable(characterData, "SkippedBonusObj")
	ensureTable(characterData, "WantedQuestList")

	return characterData
end

function AAP.Core:BuildPlayerContext(characterData)
	local lifecycle = AAP.Lifecycle or {}
	local playerReady = lifecycle.AddonLoaded and lifecycle.PlayerReady and AAP.Name and AAP.Realm and characterData ~= nil

	return {
		name = AAP.Name,
		realm = AAP.Realm,
		faction = AAP.Faction,
		level = AAP.Level,
		race = AAP.Race,
		classId = AAP.Class and AAP.Class[3],
		gender = AAP.Gender,
		characterData = characterData,
		savedVariablesReady = lifecycle.SavedVariablesReady == true,
		playerReady = playerReady == true,
	}
end

function AAP.Core:PublishEngineState(state)
	if (AAP.UI and type(AAP.UI.Publish) == "function") then
		return AAP.UI:Publish(state)
	end
	return state
end

function AAP.Core:StartEngineWhenReady(context)
	if (self.EngineStarted) then
		return self.EngineState
	end

	if (not context or not context.savedVariablesReady or not context.playerReady) then
		return nil
	end

	if (not AAP.Engine or type(AAP.Engine.Initialize) ~= "function") then
		return nil
	end

	self.EngineState = AAP.Engine:Initialize(context, AAP.Data)
	self:PublishEngineState(self.EngineState)
	self.EngineStarted = true
	AAP.Lifecycle.EngineStarted = true
	return self.EngineState
end

function AAP.Core:OnBootstrapPlayerReady()
	local characterData = self:EnsureCharacterSavedData()
	local context = self:BuildPlayerContext(characterData)

	-- UI.lua is evaluated before PLAYER_LOGIN, so it cannot initialize itself
	-- from the lifecycle flag at file-load time. Initialize it here, after the
	-- bootstrap has established player readiness and before state is published.
	if (AAP.UI and type(AAP.UI.Initialize) == "function") then
		AAP.UI:Initialize()
	end

	return self:StartEngineWhenReady(context)
end

-- Bootstrap owns WoW event registration. Core forwards only recognized runtime
-- inputs after lifecycle readiness has started the headless engine.
function AAP.Core:DispatchLegacyEvent(event, ...)
	if (not self.EngineStarted or not AAP.Engine
		or type(AAP.Engine.QueueLegacyEvent) ~= "function"
		or type(AAP.Engine.ProcessPendingEvents) ~= "function") then
		return nil
	end

	if (AAP.Engine:QueueLegacyEvent(event, ...)) then
		local state = AAP.Engine:ProcessPendingEvents()
		self.EngineState = state
		return self:PublishEngineState(state)
	end
	return self.EngineState
end
