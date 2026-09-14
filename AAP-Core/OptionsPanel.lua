AAP.AAP_panel = CreateFrame("Frame", "CLPanelFrame", UIParent)
AAP.AAP_panel.name = "Azeroth Auto Pilot"
InterfaceOptions_AddCategory(AAP.AAP_panel)
AAP_panel = {}
AAP_panel.title = AAP.AAP_panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
AAP_panel.title:SetPoint("TOPLEFT", AAP.AAP_panel, "TOPLEFT", 16, -16)
AAP_panel.title:SetText("Azeroth Auto Pilot - v" .. AAP.Version)
AAP_panel.Button1 = CreateFrame("Button", "ZPButton2", AAP.AAP_panel, "UIPanelButtonTemplate")
AAP_panel.Button1:SetPoint("TOPLEFT", AAP.AAP_panel, "TOPLEFT", 120, -100)
AAP_panel.Button1:SetSize(70, 30)
AAP_panel.Button1:SetText("Load")
AAP_panel.Button1:SetScript("OnClick", function()
	InterfaceOptionsFrame:Hide()
	HideUIPanel(GameMenuFrame)
	if (AAP.OptionsFrame and AAP.OptionsFrame.MainFrame) then AAP.OptionsFrame.MainFrame:Show() end
end)

function AAP.LoadOptionsFrame()
	if (AAP.OptionsFrame and AAP.OptionsFrame.MainFrame) then return end
	local AceGUI = LibStub("AceGUI-3.0")
	local settings = AAP1[AAP.Realm][AAP.Name]["Settings"]
	local function value(key, default) return settings[key] == nil and default or settings[key] end
	local function text(key, fallback) return (AAP_Locals and AAP_Locals[key]) or fallback end
	local function setScale(frame, scale) if (frame) then frame:SetScale(scale) end end

	AAP.OptionsFrame = {}
	local window = AceGUI:Create("Frame")
	window:SetTitle("Azeroth Auto Pilot - v" .. AAP.Version)
	window:SetStatusText("Settings are saved immediately.")
	window:SetLayout("List")
	window:SetWidth(500)
	window:SetHeight(500)
	window.frame:SetFrameStrata("DIALOG")
	window.frame:ClearAllPoints()
	window.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	window.frame:Hide()
	if (AAP.ZoneQuestOrder) then
		AAP.ZoneQuestOrder:ClearAllPoints()
		AAP.ZoneQuestOrder:SetPoint("LEFT", window.frame, "RIGHT", 20, 0)
	end
	window:SetCallback("OnClose", function()
		window:Hide()
		AAP.SettingsOpen = 0
		AAP.BookingList["ClosedSettings"] = 1
	end)
	AAP.OptionsFrame.MainFrame = window.frame
	AAP.OptionsFrame.MainFrame.AceGUI = window

	local function check(parent, name, label, key, changed)
		local widget = AceGUI:Create("CheckBox")
		widget:SetLabel(label)
		widget:SetFullWidth(true)
		widget:SetValue(value(key, 0) ~= 0)
		widget:SetCallback("OnValueChanged", function(_, _, enabled)
			settings[key] = enabled and 1 or 0
			if (changed) then changed(enabled) end
		end)
		parent:AddChild(widget)
		local proxy = { Widget = widget, frame = widget.frame }
		function proxy:SetChecked(enabled) widget:SetValue(enabled and true or false) end
		function proxy:GetChecked() return widget:GetValue() end
		function proxy:Show() widget:Show() end
		function proxy:Hide() widget:Hide() end
		AAP.OptionsFrame[name] = proxy
		return widget
	end
	local function slider(parent, name, label, key, minimum, maximum, default, changed)
		local widget = AceGUI:Create("Slider")
		widget:SetLabel(label)
		widget:SetFullWidth(true)
		widget:SetSliderValues(minimum, maximum, 1)
		widget:SetValue(value(key, default))
		widget:SetCallback("OnValueChanged", function(_, _, amount)
			amount = math.floor(amount)
			settings[key] = amount
			if (changed) then changed(amount) end
		end)
		widget.frame:EnableMouseWheel(true)
		widget.frame:SetScript("OnMouseWheel", function(_, delta)
			widget:SetValue(math.max(minimum, math.min(maximum, widget:GetValue() + delta)))
		end)
		parent:AddChild(widget)
		local proxy = { Widget = widget, frame = widget.frame }
		function proxy:SetValue(amount) widget:SetValue(amount) end
		function proxy:GetValue() return widget:GetValue() end
		function proxy:Show() widget:Show() end
		function proxy:Hide() widget:Hide() end
		AAP.OptionsFrame[name] = proxy
		return widget
	end
	local function percentSlider(parent, name, label, key, changed)
		local widget = slider(parent, name, label, key, 1, 200, 100, function(amount)
			settings[key] = amount / 100
			if (changed) then changed(settings[key]) end
		end)
		widget:SetValue(value(key, 1) * 100)
		return widget
	end

	local tabs = AceGUI:Create("TabGroup")
	tabs:SetTitle("Options")
	tabs:SetLayout("Fill")
	tabs:SetFullWidth(true)
	tabs:SetHeight(390)
	tabs:SetTabs({ { text = "Quest", value = "quest" }, { text = "Arrow", value = "arrow" }, { text = "General", value = "general" } })
	window:AddChild(tabs)

	local function buildQuest(page)
		check(page, "AutoAcceptCheckButton", text("Accept Quest", "Accept quests"), "AutoAccept")
		check(page, "AutoHandInCheckButton", text("Turn in Quest", "Turn in quests"), "AutoHandIn")
		check(page, "AutoHandInChoiceCheckButton", text("Choose Reward Ilvl", "Choose reward by item level"), "AutoHandInChoice")
		check(page, "ShowQListCheckButton", text("Show QuestList", "Show quest list"), "ShowQList", function(enabled)
			if (not enabled) then
				for index = 1, 10 do
					if (AAP.QuestList.QuestFrames[index]) then AAP.QuestList.QuestFrames[index]:Hide() end
					if (AAP.QuestList.QuestFrames["FS" .. index] and AAP.QuestList.QuestFrames["FS" .. index]["Button"]) then AAP.QuestList.QuestFrames["FS" .. index]["Button"]:Hide() end
					if (AAP.QuestList2["BF" .. index]) then AAP.QuestList2["BF" .. index]:Hide() end
				end
			end
			AAP.BookingList["PrintQStep"] = 1
		end)
		check(page, "LockQuestListCheckButton", text("Lock QuestList", "Lock quest list"), "Lock")
		percentSlider(page, "QuestListScaleSlider", "Quest list scale (%)", "Scale", function(amount)
			setScale(AAP.QuestList.ButtonParent, amount)
			setScale(AAP.QuestList.ListFrame, amount)
			setScale(AAP.QuestList21, amount)
		end)
		percentSlider(page, "QuestOrderListScaleSlider", "Guide scale (%)", "OrderListScale", function(amount) setScale(AAP.ZoneQuestOrder, amount) end)
		check(page, "QorderListzCheckButton", "Show quest order guide", "ShowQuestListOrder", function(enabled)
			if (enabled) then AAP.UpdateZoneQuestOrderList("LoadIn"); AAP.ZoneQuestOrder:Show() else AAP.ZoneQuestOrder:Hide() end
		end)
		check(page, "WorldQuestsCheckButton", "World quests", "WQs")
		check(page, "LegionCheckButton", "Enable Legion quest routes", "Legion", function()
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end)
	end
	local function buildArrow(page)
		check(page, "LockArrowCheckButton", text("Lock Arrow", "Lock arrow"), "LockArrow")
		check(page, "ShowArrowCheckButton", text("Show Arrow", "Show arrow"), "ShowArrow", function(enabled) if (enabled) then AAP.ArrowActive = 1 end end)
		percentSlider(page, "ArrowScaleSlider", "Arrow scale (%)", "ArrowScale", function(amount) setScale(AAP.ArrowFrame, amount) end)
		slider(page, "ArrowFpsSlider", "Update arrow every FPS", "ArrowFPS", 1, 5, 2)
	end
	local function buildGeneral(page)
		check(page, "CutSceneCheckButton", text("Skipped cutscene", "Skip cutscenes"), "CutScene")
		check(page, "AutoVendorCheckButton", text("AutoVendor", "Auto vendor"), "AutoVendor")
		check(page, "AutoRepairCheckButton", text("AutoRepair", "Auto repair"), "AutoRepair")
		check(page, "ShowGroupCheckButton", text("ShowGroup", "Show group"), "ShowGroup", function(enabled)
			if (not enabled) then for index = 1, 5 do if (AAP.PartyList.PartyFrames[index]) then AAP.PartyList.PartyFrames[index]:Hide() end; if (AAP.PartyList.PartyFrames2[index]) then AAP.PartyList.PartyFrames2[index]:Hide() end end end
		end)
		check(page, "AutoGossipCheckButton", text("Auto-selection of dialog", "Auto-select dialog"), "AutoGossip")
		check(page, "BannerShowCheckButton", text("BannerShow", "Show banners"), "BannerShow", function(enabled) if (enabled) then AAP.Banners.BannersFrame.Frame:Show() else AAP.Banners.BannersFrame.Frame:Hide() end end)
		percentSlider(page, "BannerScaleSlider", text("BannerScale", "Banner scale") .. " (%)", "BannerScale", function(amount)
			setScale(AAP.Banners.BannersFrame.Frame, amount)
			for index = 1, 4 do setScale(AAP.Banners.BannersFrame["Frame" .. index], amount) end
		end)
		check(page, "BlobsShowCheckButton", text("ShowBlobs", "Show minimap blobs"), "ShowBlobs", function(enabled)
			if (enabled) then AAP.OptionsFrame.MiniMapBlobAlphaSlider:Show() else AAP.RemoveIcons(); AAP.OptionsFrame.MiniMapBlobAlphaSlider:Hide() end
		end)
		local opacity = slider(page, "MiniMapBlobAlphaSlider", "Minimap blob opacity (%)", "MiniMapBlobAlpha", 1, 100, 100, function(amount)
			settings["MiniMapBlobAlpha"] = amount / 100
			AAP.Banners.BannersFrame.Frame:SetAlpha(settings["MiniMapBlobAlpha"])
			for index = 1, 20 do if (AAP["Icons"][index] and AAP["Icons"][index].texture) then AAP["Icons"][index].texture:SetAlpha(settings["MiniMapBlobAlpha"]) end end
		end)
		opacity:SetValue(value("MiniMapBlobAlpha", 1) * 100)
		if (value("ShowBlobs", 1) == 0) then AAP.OptionsFrame.MiniMapBlobAlphaSlider:Hide() end
		check(page, "MapBlobsShowCheckButton", text("ShowMapBlobs", "Show world map blobs"), "ShowMapBlobs", function(enabled) if (not enabled) then AAP:MoveMapIcons() end end)
		check(page, "ShowMap10sCheckButton", "Show 10 steps on map", "ShowMap10s", function(enabled) if (not enabled) then AAP.HBDP:RemoveAllWorldMapIcons("AAPMapOrder") end end)
		check(page, "DisableHeirloomWarningCheckButton", "Disable heirloom warning", "DisableHeirloomWarning", function() AAP.BookingList["PrintQStep"] = 1 end)
		local detach = check(page, "QuestButtonsCheckButton", "Detach quest item buttons", "QuestButtonDetatch", function(enabled)
			if (enabled) then AAP.OptionsFrame.QuestButtonsSlider:Show() else AAP.OptionsFrame.QuestButtonsSlider:Hide() end
		end)
		detach:Hide()
		local itemScale = percentSlider(page, "QuestButtonsSlider", "Quest item button scale (%)", "QuestButtons", function(amount)
			for index = 1, 20 do if (AAP.QuestList2["BF" .. index] and AAP.QuestList2["BF" .. index]["AAP_Button"]) then AAP.QuestList2["BF" .. index]["AAP_Button"]:SetScale(amount) end end
		end)
		if (value("QuestButtonDetatch", 0) == 0) then itemScale:Hide() end
	end
	tabs:SetCallback("OnGroupSelected", function(container, _, group)
		container:ReleaseChildren()
		local page = AceGUI:Create("ScrollFrame")
		page:SetLayout("List")
		page:SetFullWidth(true)
		page:SetFullHeight(true)
		container:AddChild(page)
		if (group == "quest") then buildQuest(page) elseif (group == "arrow") then buildArrow(page) else buildGeneral(page) end
	end)
	tabs:SelectTab("quest")

	local footer = AceGUI:Create("SimpleGroup")
	footer:SetLayout("Flow")
	footer:SetFullWidth(true)
	footer:SetHeight(28)
	window:AddChild(footer)
	local function button(label, width, action)
		local widget = AceGUI:Create("Button")
		widget:SetText(label)
		widget:SetWidth(width)
		widget:SetCallback("OnClick", action)
		footer:AddChild(widget)
	end
	button(text("Keybinds", "Keybinds"), 105, function() KeyBindingFrame_LoadUI(); KeyBindingFrame:Show() end)
	button("Reset", 80, function() AAP.ResetSettings() end)
	button("Close", 80, function() window:Hide(); AAP.SettingsOpen = 0; AAP.BookingList["ClosedSettings"] = 1 end)
end
