-- Stage 5: Ace3 presentation layer.
-- UI owns presentation only. It consumes detached state published by AAP.UI.
-- No quest/routing decisions are made here.

AAP = AAP or {}
AAP.UI = AAP.UI or {}
AAP.UI.Dependencies = AAP.UI.Dependencies or {}
AAP.UI.Initialized = AAP.UI.Initialized or false
AAP.UI.State = AAP.UI.State or nil
AAP.UI._listeners = AAP.UI._listeners or {}
AAP.UI._nextListenerId = AAP.UI._nextListenerId or 0
AAP.UI._window = AAP.UI._window or nil
AAP.UI._refreshing = false

-- Resolve AceGUI through LibStub first. Do not depend on a global AceGUI name.
local AceGUI = (LibStub and LibStub("AceGUI-3.0", true)) or _G.AceGUI
AAP.UI.Dependencies.AceGUI = AceGUI

local function safeText(value)
    if value == nil then return "" end
    return tostring(value)
end

local function countTable(t)
    local n = 0
    if type(t) == "table" then
        for _ in pairs(t) do n = n + 1 end
    end
    return n
end

local function sortedQuestIds(active)
    local ids = {}
    if type(active) ~= "table" then return ids end
    for id, enabled in pairs(active) do
        if enabled == true then ids[#ids + 1] = id end
    end
    table.sort(ids)
    return ids
end

local function questTitle(id)
    if AAP.Data and type(AAP.Data.QuestTitleFor) == "function" then
        return AAP.Data:QuestTitleFor(id)
    end
    return nil
end

local function styleFrame(frame)
    if not frame then return end
    frame:SetWidth(520)
    frame:SetHeight(560)
    frame:SetLayout("Flow")
    frame:SetTitle("Azeroth Auto Pilot")
    frame:SetStatusText("Legion 7.3.5")
end

local function addLabel(container, text, width)
    local label = AceGUI:Create("Label")
    label:SetText(text)
    label:SetFullWidth(true)
    if width then label:SetWidth(width) end
    container:AddChild(label)
    return label
end

function AAP.UI:Initialize()
    if self.Initialized then return self end
    self.Initialized = true
    self:EnsureWindow()
    if self.State then self:Refresh(self.State) end
    return self
end

function AAP.UI:GetState()
    return self.State
end

function AAP.UI:Subscribe(callback)
    if type(callback) ~= "function" then return nil end
    self._nextListenerId = self._nextListenerId + 1
    local id = self._nextListenerId
    self._listeners[id] = callback
    return id
end

function AAP.UI:Unsubscribe(id)
    if id ~= nil then self._listeners[id] = nil end
end

function AAP.UI:Publish(state)
    self.State = state
    if not self.Initialized then return state end
    self:Refresh(state)
    for id, callback in pairs(self._listeners) do
        local ok = pcall(callback, state)
        if not ok then self._listeners[id] = nil end
    end
    return state
end

function AAP.UI:EnsureWindow()
    if self._window then return self._window end

    if not AceGUI then
        error("AAP UI: AceGUI-3.0 could not be loaded")
    end
    if type(AceGUI.Create) ~= "function" then
        error("AAP UI: AceGUI-3.0 is loaded but Create() is unavailable")
    end

    local window = AceGUI:Create("Window")
    if not window then
        error("AAP UI: AceGUI Window widget could not be created")
    end

    styleFrame(window)
    window:SetCallback("OnClose", function(widget)
        self._window = nil
        AceGUI:Release(widget)
    end)

    local header = AceGUI:Create("Heading")
    header:SetText("Quest & Route Overview")
    header:SetFullWidth(true)
    window:AddChild(header)

    local summary = AceGUI:Create("Label")
    summary:SetFullWidth(true)
    summary:SetFontObject(GameFontHighlight)
    window:AddChild(summary)
    self._summary = summary

    local current = AceGUI:Create("InlineGroup")
    current:SetTitle("Current Step")
    current:SetFullWidth(true)
    current:SetLayout("Flow")
    window:AddChild(current)
    self._currentGroup = current

    local quests = AceGUI:Create("InlineGroup")
    quests:SetTitle("Active Quests")
    quests:SetFullWidth(true)
    quests:SetLayout("Flow")
    window:AddChild(quests)
    self._questGroup = quests

    local navigation = AceGUI:Create("InlineGroup")
    navigation:SetTitle("Navigation")
    navigation:SetFullWidth(true)
    navigation:SetLayout("Flow")
    window:AddChild(navigation)
    self._navigationGroup = navigation

    local buttons = AceGUI:Create("SimpleGroup")
    buttons:SetFullWidth(true)
    buttons:SetLayout("Flow")
    window:AddChild(buttons)

    local refresh = AceGUI:Create("Button")
    refresh:SetText("Refresh")
    refresh:SetWidth(120)
    refresh:SetCallback("OnClick", function()
        if AAP.Engine and type(AAP.Engine.RefreshQuestState) == "function" then
            local state = AAP.Engine:RefreshQuestState()
            self:Publish(state)
        end
    end)
    buttons:AddChild(refresh)

    local close = AceGUI:Create("Button")
    close:SetText("Close")
    close:SetWidth(120)
    close:SetCallback("OnClick", function() self:Hide() end)
    buttons:AddChild(close)

    self._window = window
    self:Refresh(self.State)
    return window
end

function AAP.UI:Refresh(state)
    if not self.Initialized or self._refreshing then return end
    self._refreshing = true
    state = state or self.State
    self.State = state

    local window = self:EnsureWindow()
    if not window then self._refreshing = false; return end

    local active = state and state.quests and state.quests.active or {}
    local questCount = countTable(active)
    local route = state and state.active and safeText(state.routeKey) or "No route selected"
    local step = state and state.stepIndex and safeText(state.stepIndex) or "-"

    self._summary:SetText("Route: |cffffd100" .. route .. "|r   Step: |cffffd100" .. step .. "|r   Active quests: |cffffd100" .. questCount .. "|r")

    self._currentGroup:ReleaseChildren()
    if state and state.step then
        local kind = state.step.kind and safeText(state.step.kind) or "Route step"
        addLabel(self._currentGroup, "Type: " .. kind)
        if state.step.questIds then
            for _, id in ipairs(state.step.questIds) do
                addLabel(self._currentGroup, "Quest " .. safeText(id) .. (questTitle(id) and (": " .. safeText(questTitle(id))) or ""))
            end
        end
    else
        addLabel(self._currentGroup, state and state.active and "Current route step has no quest metadata." or "No active route step.")
    end

    self._questGroup:ReleaseChildren()
    local ids = sortedQuestIds(active)
    if #ids == 0 then
        addLabel(self._questGroup, "No quests currently in the quest log.")
    else
        for _, id in ipairs(ids) do
            local title = questTitle(id) or "Unknown quest"
            local line = "|cffffffff" .. safeText(title) .. "|r  |cff888888(" .. safeText(id) .. ")|r"
            local objectives = state.quests.objectives and state.quests.objectives[id]
            if type(objectives) == "table" then
                for index = 1, #objectives do
                    local obj = objectives[index]
                    if obj then
                        local mark = obj.completed and "|cff40ff40[✓]|r " or "|cffaaaaaa[ ]|r "
                        line = line .. "\n" .. mark .. safeText(obj.text)
                    end
                end
            end
            addLabel(self._questGroup, line)
        end
    end

    self._navigationGroup:ReleaseChildren()
    local nav = state and state.navigation
    if nav and nav.active then
        if nav.target then
            addLabel(self._navigationGroup, string.format("Target: %.2f, %.2f", nav.target.x, nav.target.y))
        end
        if nav.trigger then
            addLabel(self._navigationGroup, string.format("Trigger: %.2f, %.2f", nav.trigger.x, nav.trigger.y))
        end
        if nav.range then addLabel(self._navigationGroup, "Range: " .. safeText(nav.range)) end
    else
        addLabel(self._navigationGroup, "No navigation target for the current step.")
    end

    if state and state.travel and state.travel.active then
        addLabel(self._navigationGroup, "Travel: " .. safeText(state.travel.kind) .. " → " .. safeText(state.travel.destination) .. " (" .. safeText(state.travel.decision) .. ")")
    end
    self._refreshing = false
end

function AAP.UI:Show()
    local window = self:EnsureWindow()
    if not window then return false end
    if self.State then
        self:Refresh(self.State)
    end
    window:Show()
    return true
end

function AAP.UI:Hide()
    if self._window then self._window:Hide() end
end

function AAP.UI:Toggle()
    local window = self:EnsureWindow()
    if not window then return false end

    if window.frame and window.frame:IsShown() then
        self:Hide()
        return false
    end

    return self:Show()
end

function AAP.UI:Clear()
    self.State = nil
    if self._summary then self._summary:SetText("") end
end

SLASH_AAP1 = "/aap"
SlashCmdList.AAP = function(message)
    message = string.lower(message or "")

    if not AAP.UI then
        print("|cffff0000AAP: UI module is not initialized.|r")
        return
    end

    -- Defensive initialization: /aap must work independently of lifecycle timing.
    if type(AAP.UI.Initialize) == "function" then
        AAP.UI:Initialize()
    end

    if message == "debug" then
        print("AAP UI:", AAP.UI ~= nil)
        print("AAP UI Initialized:", AAP.UI and AAP.UI.Initialized)
        print("AceGUI:", AceGUI ~= nil)
        print("AceGUI.Create:", AceGUI and type(AceGUI.Create))
        print("AAP UI Window:", AAP.UI and AAP.UI._window ~= nil)
        if AAP.UI and AAP.UI._window then
            print("Window Frame:", AAP.UI._window.frame ~= nil)
            if AAP.UI._window.frame then
                print("Window Shown:", AAP.UI._window.frame:IsShown())
            end
        end
        return
    end

    if message == "hide" or message == "close" then
        AAP.UI:Hide()
    elseif message == "refresh" then
        if AAP.Engine and type(AAP.Engine.RefreshQuestState) == "function" then
            AAP.UI:Publish(AAP.Engine:RefreshQuestState())
        else
            AAP.UI:Refresh(AAP.UI.State)
        end
    else
        AAP.UI:Toggle()
    end
end

-- Lazy initialization: the UI object exists at load, but the Ace3 window is
-- created only after the player is ready. Core also initializes it from the
-- PLAYER_LOGIN / PLAYER_ENTERING_WORLD readiness path.
if AAP.Lifecycle and AAP.Lifecycle.PlayerReady then
    AAP.UI:Initialize()
end
