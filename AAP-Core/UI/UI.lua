-- Stage 5: polished Ace3 presentation layer.
-- UI renders detached state from AAP.Engine. It does not own route decisions,
-- quest progression decisions, or navigation decisions.

AAP = AAP or {}
AAP.UI = AAP.UI or {}
AAP.UI.Dependencies = AAP.UI.Dependencies or {}
AAP.UI.Initialized = AAP.UI.Initialized or false
AAP.UI.State = AAP.UI.State or nil
AAP.UI._listeners = AAP.UI._listeners or {}
AAP.UI._nextListenerId = AAP.UI._nextListenerId or 0
AAP.UI._window = AAP.UI._window or nil
AAP.UI._tabs = AAP.UI._tabs or nil
AAP.UI._tabContainers = AAP.UI._tabContainers or nil
AAP.UI._tabScrolls = AAP.UI._tabScrolls or nil
AAP.UI._activeTabContainer = AAP.UI._activeTabContainer or nil
AAP.UI._selectedTab = AAP.UI._selectedTab or "guide"
AAP.UI._refreshing = false
AAP.UI._guide = AAP.UI._guide or nil

local AceGUI = (LibStub and LibStub("AceGUI-3.0", true)) or _G.AceGUI
AAP.UI.Dependencies.AceGUI = AceGUI

local DEFAULTS = {
    scale = 1.00,
    width = 520,
    height = 560,
    fontSize = 14,
    iconSize = 24,
    opacity = 0.94,
    locked = false,
    showObjectives = true,
    showRoute = true,
    x = 0,
    y = 0,
    guideScale = 1.00,
    guideShown = true,
}

local function settings()
    AAP3 = type(AAP3) == "table" and AAP3 or {}
    AAP3.UI = type(AAP3.UI) == "table" and AAP3.UI or {}
    for key, value in pairs(DEFAULTS) do
        if AAP3.UI[key] == nil then AAP3.UI[key] = value end
    end
    return AAP3.UI
end

local function safeText(value)
    return value == nil and "" or tostring(value)
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

local function objectiveProgress(text, completed)
    if completed then return "✓" end
    if type(text) ~= "string" then return "" end
    local current, total = string.match(text, "(%d+)%s*/%s*(%d+)")
    if current and total then return current .. "/" .. total end
    current, total = string.match(text, "(%d+)%s+of%s+(%d+)")
    if current and total then return current .. "/" .. total end
    return ""
end

local function questObjectiveSummary(objectives)
    if type(objectives) ~= "table" then return 0, 0 end
    local done, total = 0, 0
    for _, objective in ipairs(objectives) do
        if objective then
            total = total + 1
            if objective.completed then done = done + 1 end
        end
    end
    return done, total
end

local function stepKind(state)
    return state and state.step and safeText(state.step.kind) or "Route step"
end

local function framePosition(frame)
    if not frame then return 0, 0 end
    local left = frame:GetLeft()
    local bottom = frame:GetBottom()
    if not left or not bottom then return 0, 0 end
    local uiLeft = UIParent:GetLeft() or 0
    local uiBottom = UIParent:GetBottom() or 0
    return left - uiLeft, bottom - uiBottom
end

local function applyPosition(frame)
    local s = settings()
    if not frame then return end
    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", s.x, s.y)
end

local function setFont(widget, size)
    if widget and widget.SetFontObject and GameFontNormal then
        widget:SetFontObject(size <= 13 and GameFontNormalSmall or GameFontNormal)
    end
end

local function addLabel(container, text, width)
    local label = AceGUI:Create("Label")
    label:SetText(text or "")
    label:SetFullWidth(width == nil)
    if width then label:SetWidth(width) end
    setFont(label, settings().fontSize)
    container:AddChild(label)
    return label
end

local function addIconLabel(container, icon, text)
    local group = AceGUI:Create("SimpleGroup")
    group:SetFullWidth(true)
    group:SetLayout("Flow")
    local image = AceGUI:Create("Icon")
    image:SetImage(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    image:SetImageSize(settings().iconSize, settings().iconSize)
    image:SetWidth(settings().iconSize + 10)
    image:SetHeight(settings().iconSize + 10)
    group:AddChild(image)
    local label = addLabel(group, text)
    label:SetWidth(420)
    group:AddChild(label)
    container:AddChild(group)
    return group
end

local function makeHeader(container, title, subtitle)
    local group = AceGUI:Create("SimpleGroup")
    group:SetFullWidth(true)
    group:SetLayout("Flow")
    local heading = AceGUI:Create("Heading")
    heading:SetText(title)
    heading:SetFullWidth(true)
    group:AddChild(heading)
    if subtitle then addLabel(group, subtitle) end
    container:AddChild(group)
    return group
end

function AAP.UI:Initialize()
    settings()
    if self.Initialized then
        self:EnsureGuide()
        return self
    end
    self.Initialized = true
    self:EnsureWindow()
    self:EnsureGuide()
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
    self:UpdateGuide()
    for id, callback in pairs(self._listeners) do
        local ok = pcall(callback, state)
        if not ok then self._listeners[id] = nil end
    end
    return state
end

function AAP.UI:ApplyWindowSettings()
    local s = settings()
    local window = self._window
    if not window then return end
    window:SetWidth(s.width)
    window:SetHeight(s.height)
    window:SetScale(s.scale)
    applyPosition(window.frame)
    if window.frame and window.frame.SetAlpha then window.frame:SetAlpha(s.opacity) end
    if window.frame and window.frame.SetMovable then window.frame:SetMovable(not s.locked) end
    if window.frame and window.frame.EnableMouse then window.frame:EnableMouse(true) end
end

function AAP.UI:HookWindowMovement(window)
    if not window or not window.frame or window._aapMovementHooked then return end
    window._aapMovementHooked = true
    local frame = window.frame
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:HookScript("OnMouseUp", function()
        local s = settings()
        if s.locked then return end
        s.x, s.y = framePosition(frame)
    end)
end

function AAP.UI:CreateTabContainer()
    local outer = AceGUI:Create("SimpleGroup")
    outer:SetFullWidth(true)
    outer:SetFullHeight(true)
    outer:SetLayout("Fill")

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetFullWidth(true)
    scroll:SetFullHeight(true)
    scroll:SetLayout("Flow")
    outer:AddChild(scroll)

    return outer, scroll
end

function AAP.UI:BuildTabContainers()
    self._tabContainers = {}
    self._tabScrolls = {}
    local names = { "guide", "quests", "route", "settings" }
    for _, name in ipairs(names) do
        local outer, scroll = self:CreateTabContainer()
        self._tabContainers[name] = outer
        self._tabScrolls[name] = scroll
    end
end

function AAP.UI:DetachActiveTabContainer()
    local tabs = self._tabs
    local active = self._activeTabContainer
    if not tabs or not active then return end
    for i = #tabs.children, 1, -1 do
        if tabs.children[i] == active then
            table.remove(tabs.children, i)
            break
        end
    end
    active.frame:Hide()
    active.parent = nil
    self._activeTabContainer = nil
end

function AAP.UI:AttachTabContainer(group)
    local tabs = self._tabs
    local container = self._tabContainers and self._tabContainers[group]
    if not tabs or not container then return end
    if self._activeTabContainer == container then return end
    self:DetachActiveTabContainer()
    tabs:AddChild(container)
    self._activeTabContainer = container
end

function AAP.UI:ReleaseTabContainers()
    local containers = self._tabContainers
    self._tabContainers = nil
    self._tabScrolls = nil
    self._activeTabContainer = nil
    if not containers then return end
    for _, container in pairs(containers) do
        if container and container.parent ~= self._tabs then
            AceGUI:Release(container)
        end
    end
end

function AAP.UI:EnsureWindow()
    if self._window then
        self:ApplyWindowSettings()
        return self._window
    end
    if not AceGUI then error("AAP UI: AceGUI-3.0 could not be loaded") end
    if type(AceGUI.Create) ~= "function" then error("AAP UI: AceGUI-3.0 Create() unavailable") end

    local window = AceGUI:Create("Window")
    if not window then error("AAP UI: AceGUI Window widget could not be created") end
    window:SetTitle("Azeroth Auto Pilot")
    window:SetStatusText("Legion 7.3.5")
    window:SetLayout("Fill")
    window:SetCallback("OnClose", function(widget)
        self._window = nil
        local containers = self._tabContainers
        self._tabContainers = nil
        self._tabScrolls = nil
        self._activeTabContainer = nil
        self._tabs = nil
        AceGUI:Release(widget)
        if containers then
            for _, container in pairs(containers) do
                if container and container.parent == nil then
                    AceGUI:Release(container)
                end
            end
        end
    end)
    self._window = window
    self:HookWindowMovement(window)
    self:ApplyWindowSettings()

    local tabs = AceGUI:Create("TabGroup")
    tabs:SetFullWidth(true)
    tabs:SetFullHeight(true)
    tabs:SetLayout("Fill")
    tabs:SetTabs({
        { text = "Guide", value = "guide" },
        { text = "Quests", value = "quests" },
        { text = "Route", value = "route" },
        { text = "Settings", value = "settings" },
    })
    tabs:SetCallback("OnGroupSelected", function(_, _, group)
        self._selectedTab = group
        self:RenderTab(group)
    end)
    window:AddChild(tabs)
    self._tabs = tabs
    self:BuildTabContainers()
    tabs:SelectTab(self._selectedTab or "guide")
    return window
end

function AAP.UI:RenderTab(group)
    if not self._tabs or not self._tabScrolls then return end
    group = group or self._selectedTab or "guide"
    self._selectedTab = group
    self:AttachTabContainer(group)

    local container = self._tabScrolls[group]
    if not container then return end

    -- Only the transient content widgets are recycled. The ScrollFrame itself
    -- survives refreshes, so its scroll position is retained.
    container:ReleaseChildren()
    if group == "quests" then
        self:RenderQuests(container)
    elseif group == "route" then
        self:RenderRoute(container)
    elseif group == "settings" then
        self:RenderSettings(container)
    else
        self:RenderGuide(container)
    end
end

function AAP.UI:RenderGuide(container)
    local state = self.State or {}
    local s = settings()
    local route = state.active and safeText(state.routeKey) or "No route selected"
    local index = state.stepIndex and safeText(state.stepIndex) or "-"
    local questIds = state.step and state.step.questIds or {}

    makeHeader(container, "Current Objective", "Follow the active route step. Navigation remains owned by the engine.")

    local card = AceGUI:Create("InlineGroup")
    card:SetTitle(state.step and safeText(state.step.name) or stepKind(state))
    card:SetFullWidth(true)
    card:SetLayout("Flow")
    container:AddChild(card)

    addLabel(card, "STEP " .. index .. "   •   " .. stepKind(state))
    if #questIds > 0 then
        for _, questId in ipairs(questIds) do
            local title = questTitle(questId) or ("Quest " .. safeText(questId))
            addIconLabel(card, "Interface\\Icons\\INV_Misc_Book_09", title)
            if s.showObjectives then
                local objectives = state.quests and state.quests.objectives and state.quests.objectives[questId]
                if objectives then
                    for _, objective in ipairs(objectives) do
                        if objective then
                            local progress = objectiveProgress(objective.text, objective.completed)
                            local prefix = objective.completed and "|cff40ff40✓|r " or "|cffaaaaaa•|r "
                            if progress ~= "" and not objective.completed then
                                prefix = "|cffffd100[" .. progress .. "]|r "
                            end
                            addLabel(card, prefix .. safeText(objective.text))
                        end
                    end
                end
            end
        end
    else
        addLabel(card, state.step and "This route step has no quest metadata." or "No active route step.")
    end

    if state.stepIndex then
        addLabel(card, "Next step: " .. safeText(state.stepIndex + 1))
    end

    if s.showRoute then
        local progress = state.stepIndex and (safeText(state.stepIndex) .. " / route") or "-"
        addLabel(container, "Route progress: " .. progress .. "   •   " .. route)
    end

    local travel = state.travel
    local travelText = "No travel action required"
    if travel and travel.active then
        travelText = safeText(travel.kind) .. " → " .. safeText(travel.destination)
        if travel.decision then travelText = travelText .. "  (" .. safeText(travel.decision) .. ")" end
    end
    local travelGroup = AceGUI:Create("InlineGroup")
    travelGroup:SetTitle("Travel")
    travelGroup:SetFullWidth(true)
    travelGroup:SetLayout("Flow")
    container:AddChild(travelGroup)
    addLabel(travelGroup, travelText)
end

function AAP.UI:RenderQuests(container)
    local state = self.State or {}
    makeHeader(container, "Quest Progress", "Live quest-log state supplied by the engine.")
    local active = state.quests and state.quests.active or {}
    local ids = sortedQuestIds(active)
    if #ids == 0 then
        addLabel(container, "No active quests.")
        return
    end
    for _, questId in ipairs(ids) do
        local objectives = state.quests.objectives and state.quests.objectives[questId] or {}
        local done, total = questObjectiveSummary(objectives)
        local title = questTitle(questId) or ("Quest " .. safeText(questId))
        local group = AceGUI:Create("InlineGroup")
        group:SetTitle(title)
        group:SetFullWidth(true)
        group:SetLayout("Flow")
        container:AddChild(group)
        addLabel(group, "ID " .. safeText(questId) .. "   •   Progress " .. done .. "/" .. total)
        for _, objective in ipairs(objectives) do
            if objective then
                local progress = objectiveProgress(objective.text, objective.completed)
                local marker = objective.completed and "|cff40ff40✓|r" or "|cffaaaaaa○|r"
                local suffix = progress ~= "" and "  |cffffd100" .. progress .. "|r" or ""
                addLabel(group, marker .. " " .. safeText(objective.text) .. suffix)
            end
        end
    end
end

function AAP.UI:RenderRoute(container)
    local state = self.State or {}
    makeHeader(container, "Route Progress", "Route selection and navigation state are produced by AAP.Engine.")
    local group = AceGUI:Create("InlineGroup")
    group:SetTitle(state.active and safeText(state.routeKey) or "Inactive")
    group:SetFullWidth(true)
    group:SetLayout("Flow")
    container:AddChild(group)
    addLabel(group, "Current step: " .. (state.stepIndex and safeText(state.stepIndex) or "-"))
    addLabel(group, "Step type: " .. stepKind(state))
    if state.step and state.step.name then addLabel(group, "Step name: " .. safeText(state.step.name)) end

    local nav = state.navigation
    local navGroup = AceGUI:Create("InlineGroup")
    navGroup:SetTitle("Navigation")
    navGroup:SetFullWidth(true)
    navGroup:SetLayout("Flow")
    container:AddChild(navGroup)
    if nav and nav.active then
        if nav.target then addLabel(navGroup, string.format("Target: %.2f, %.2f", nav.target.x, nav.target.y)) end
        if nav.trigger then addLabel(navGroup, string.format("Trigger: %.2f, %.2f", nav.trigger.x, nav.trigger.y)) end
        if nav.range then addLabel(navGroup, "Range: " .. safeText(nav.range)) end
        if nav.cRange then addLabel(navGroup, "Conditional range step") end
    else
        addLabel(navGroup, "No navigation target for this step.")
    end

    local travel = state.travel
    if travel and travel.active then
        addLabel(navGroup, "Travel: " .. safeText(travel.kind) .. " → " .. safeText(travel.destination))
        addLabel(navGroup, "Decision: " .. safeText(travel.decision))
    end
end

function AAP.UI:RenderSettings(container)
    local s = settings()
    makeHeader(container, "Interface Settings", "Changes are saved per character.")

    local function slider(name, key, min, max, step)
        local slider = AceGUI:Create("Slider")
        slider:SetLabel(name)
        slider:SetSliderValues(min, max, step)
        slider:SetValue(s[key])
        slider:SetFullWidth(true)
        slider:SetCallback("OnValueChanged", function(_, _, value)
            s[key] = value
            self:ApplyWindowSettings()
            if key == "fontSize" or key == "iconSize" then
                C_Timer.After(0, function() self:Refresh(self.State) end)
            end
        end)
        container:AddChild(slider)
    end

    slider("Scale", "scale", 0.70, 1.50, 0.05)
    slider("Width", "width", 360, 760, 10)
    slider("Height", "height", 360, 760, 10)
    slider("Font size", "fontSize", 10, 20, 1)
    slider("Icon size", "iconSize", 16, 48, 2)
    slider("Opacity", "opacity", 0.35, 1.00, 0.05)

    local locked = AceGUI:Create("CheckBox")
    locked:SetLabel("Lock position")
    locked:SetValue(s.locked)
    locked:SetCallback("OnValueChanged", function(_, _, value)
        s.locked = value == true
        self:ApplyWindowSettings()
    end)
    container:AddChild(locked)

    local objectives = AceGUI:Create("CheckBox")
    objectives:SetLabel("Show objective text")
    objectives:SetValue(s.showObjectives)
    objectives:SetCallback("OnValueChanged", function(_, _, value)
        s.showObjectives = value == true
        C_Timer.After(0, function() self:Refresh(self.State) end)
    end)
    container:AddChild(objectives)

    local route = AceGUI:Create("CheckBox")
    route:SetLabel("Show route information")
    route:SetValue(s.showRoute)
    route:SetCallback("OnValueChanged", function(_, _, value)
        s.showRoute = value == true
        C_Timer.After(0, function() self:Refresh(self.State) end)
    end)
    container:AddChild(route)

    local guide = AceGUI:Create("CheckBox")
    guide:SetLabel("Show guide arrow")
    guide:SetValue(s.guideShown)
    guide:SetCallback("OnValueChanged", function(_, _, value)
        s.guideShown = value == true
        self:UpdateGuide()
    end)
    container:AddChild(guide)

    local reset = AceGUI:Create("Button")
    reset:SetText("Reset UI Position")
    reset:SetWidth(180)
    reset:SetCallback("OnClick", function()
        s.x, s.y = 0, 0
        self:ApplyWindowSettings()
    end)
    container:AddChild(reset)

    local defaults = AceGUI:Create("Button")
    defaults:SetText("Reset All UI Settings")
    defaults:SetWidth(180)
    defaults:SetCallback("OnClick", function()
        for key, value in pairs(DEFAULTS) do s[key] = value end
        self:ApplyWindowSettings()
        self:EnsureGuide()
        C_Timer.After(0, function()
            self:Refresh(self.State)
            self:UpdateGuide()
        end)
    end)
    container:AddChild(defaults)
end

function AAP.UI:Refresh(state)
    if not self.Initialized or self._refreshing then return end
    self._refreshing = true
    self.State = state or self.State
    if self._tabs then
        self:RenderTab(self._selectedTab or "guide")
    end
    self._refreshing = false
end

function AAP.UI:EnsureGuide()
    if self._guide then return self._guide end
    local frame = CreateFrame("Frame", "AAPGuideFrame", UIParent)
    frame:SetSize(72, 72)
    frame:SetFrameStrata("HIGH")
    frame:SetClampedToScreen(true)
    frame:Hide()

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(frame)
    icon:SetTexture("Interface\\Minimap\\MinimapArrow")
    frame.icon = icon

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOP", frame, "BOTTOM", 0, -2)
    text:SetTextColor(1, 0.82, 0, 1)
    frame.text = text

    self._guide = frame
    return frame
end

function AAP.UI:UpdateGuide()
    local frame = self:EnsureGuide()
    local s = settings()
    local nav = self.State and self.State.navigation
    if not s.guideShown or not nav or not nav.active or not nav.target then
        frame:Hide()
        return
    end

    frame:SetScale(s.guideScale)
    frame.text:SetText(nav.range and ("" .. math.floor(nav.range + 0.5) .. " yd") or "")

    -- The engine supplies the target. The UI only converts that detached target
    -- into a visual bearing; it never chooses or modifies the destination.
    local px, py = GetPlayerMapPosition("player")
    if px and py and px ~= 0 and py ~= 0 then
        local tx = nav.target.x / 100
        local ty = nav.target.y / 100
        local dx, dy = tx - px, ty - py
        local angle = math.atan2(dy, dx) - (GetPlayerFacing() or 0) - math.pi / 2
        frame.icon:SetRotation(angle)
    else
        frame.icon:SetRotation(0)
    end
    frame:Show()
end

function AAP.UI:Show()
    local window = self:EnsureWindow()
    if not window then return false end
    self:ApplyWindowSettings()
    window:Show()
    self:Refresh(self.State)
    self:UpdateGuide()
    return true
end

function AAP.UI:Hide()
    if self._window then self._window:Hide() end
    if self._guide then self._guide:Hide() end
end

function AAP.UI:Toggle()
    local window = self:EnsureWindow()
    if window and window.frame and window.frame:IsShown() then
        self:Hide()
        return false
    end
    return self:Show()
end

function AAP.UI:Clear()
    self.State = nil
    self:UpdateGuide()
end

SLASH_AAP1 = "/aap"
SlashCmdList.AAP = function(message)
    message = string.lower(message or "")
    if not AAP.UI then
        print("|cffff0000AAP: UI module is not initialized.|r")
        return
    end
    AAP.UI:Initialize()

    if message == "debug" then
        print("AAP UI:", true)
        print("Initialized:", AAP.UI.Initialized)
        print("AceGUI:", AceGUI ~= nil)
        print("AceGUI.Create:", AceGUI and type(AceGUI.Create))
        print("Window:", AAP.UI._window ~= nil)
        print("Guide:", AAP.UI._guide ~= nil)
        print("Selected tab:", AAP.UI._selectedTab or "guide")
        return
    elseif message == "hide" or message == "close" then
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

-- Bootstrap/Core owns readiness. This remains a no-op during file load on a
-- normal login because PLAYER_LOGIN occurs after the TOC has been evaluated.
if AAP.Lifecycle and AAP.Lifecycle.PlayerReady then
    AAP.UI:Initialize()
end
