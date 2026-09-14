-- Stage 1 bootstrap: lifecycle and saved-variable foundation only.
-- This file must stay UI-free. The unnamed frame below is an event dispatcher,
-- not an addon presentation frame.

AAP = AAP or {}
AAP.Lifecycle = AAP.Lifecycle or {}
AAP.BookingList = AAP.BookingList or {}
AAP.QuestStepList = AAP.QuestStepList or {}
AAP.QuestList = AAP.QuestList or {}
AAP.NPCList = AAP.NPCList or {}
AAP.Icons = AAP.Icons or {}
AAP.MapIcons = AAP.MapIcons or {}
AAP.Breadcrums = AAP.Breadcrums or {}
AAP.ActiveQuests = AAP.ActiveQuests or {}
AAP.GroupListSteps = AAP.GroupListSteps or {}
AAP.MapZoneIcons = AAP.MapZoneIcons or {}
AAP.MapZoneIconsRed = AAP.MapZoneIconsRed or {}

local ADDON_NAME = "AAP-Core"

local function forwardRuntimeEvent(event, ...)
	if (AAP.Core and type(AAP.Core.DispatchLegacyEvent) == "function") then
		AAP.Core:DispatchLegacyEvent(event, ...)
	end
end

function AAP:InitializeSavedVariables()
	if (type(AAP1) ~= "table") then
		AAP1 = {}
	end

	self.Lifecycle.SavedVariablesReady = true
	return AAP1
end

function AAP:RefreshPlayerState()
	local playerName = UnitName("player")
	local realmName = GetRealmName()

	if (playerName and realmName) then
		self.Name = playerName
		self.Realm = string.gsub(realmName, "%s+", "")
	end

	self.Faction = UnitFactionGroup("player")
	self.Level = UnitLevel("player")
	self.RaceLocale, self.Race = UnitRace("player")
	self.Class = self.Class or {}
	self.Class[1], self.Class[2], self.Class[3] = UnitClass("player")
	self.Gender = UnitSex("player")

	return self.Name, self.Realm
end

function AAP:InitializeCore()
	if (self.Lifecycle.CoreInitialized) then
		return
	end

	self.Version = tonumber(GetAddOnMetadata(ADDON_NAME, "Version"))
	self.RegisterChat = RegisterAddonMessagePrefix("AAPChat")
	self.Lifecycle.CoreInitialized = true
end

function AAP:HandleLifecycleEvent(event, ...)
	if (event == "ADDON_LOADED") then
		local loadedAddon = ...
		if (loadedAddon ~= ADDON_NAME) then
			return
		end

		self:InitializeSavedVariables()
		self:InitializeCore()
		self.Lifecycle.AddonLoaded = true
		return
	end

	if (event == "PLAYER_LOGIN") then
		self:RefreshPlayerState()
		self.Lifecycle.PlayerLogin = true
		self.Lifecycle.PlayerReady = true
		if (self.Core and type(self.Core.OnBootstrapPlayerReady) == "function") then
			self.Core:OnBootstrapPlayerReady()
		end
		forwardRuntimeEvent(event, ...)
		return
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		self:RefreshPlayerState()
		self.Lifecycle.PlayerEnteringWorld = true
		self.Lifecycle.PlayerReady = true
		self.Lifecycle.WorldEntryCount = (self.Lifecycle.WorldEntryCount or 0) + 1
		if (self.Core and type(self.Core.OnBootstrapPlayerReady) == "function") then
			self.Core:OnBootstrapPlayerReady()
		end
		forwardRuntimeEvent(event, ...)
		return
	end

	forwardRuntimeEvent(event, ...)
end

AAP.CoreEventFrame = CreateFrame("Frame")
AAP.CoreEventFrame:RegisterEvent("ADDON_LOADED")
AAP.CoreEventFrame:RegisterEvent("PLAYER_LOGIN")
AAP.CoreEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
AAP.CoreEventFrame:RegisterEvent("ZONE_CHANGED")
AAP.CoreEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
AAP.CoreEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
AAP.CoreEventFrame:RegisterEvent("QUEST_LOG_UPDATE")
AAP.CoreEventFrame:RegisterEvent("QUEST_ACCEPTED")
AAP.CoreEventFrame:RegisterEvent("QUEST_REMOVED")
AAP.CoreEventFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
AAP.CoreEventFrame:RegisterEvent("PLAYER_CONTROL_LOST")
AAP.CoreEventFrame:RegisterEvent("TAXIMAP_OPENED")
AAP.CoreEventFrame:RegisterEvent("TAXIMAP_CLOSED")
AAP.CoreEventFrame:SetScript("OnEvent", function(_, event, ...)
	AAP:HandleLifecycleEvent(event, ...)
end)
