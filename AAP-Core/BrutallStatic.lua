AAP.BrutallCC = {}
AAP.BrutallCC.BrutallFrame = {}
AAP.BrutallCC.BrutallFrame = CreateFrame("frame", "AAP_PartyListFrame1", UIParent)
AAP.BrutallCC.BrutallFrame:SetWidth(1)
AAP.BrutallCC.BrutallFrame:SetHeight(1)
AAP.BrutallCC.BrutallFrame:SetMovable(true)
AAP.BrutallCC.BrutallFrame:EnableMouse(true)
AAP.BrutallCC.BrutallFrame:SetFrameStrata("LOW")
AAP.BrutallCC.BrutallFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
AAP.BrutallCC.Timer = 0
AAP.BrutallCC.TargetTimer = 0


function AAP_BrutallShoFunc(AAPCID)
	local Wheight = 0
	local capabilities = AAP.Data:NPCFor(AAPCID)
	if (not capabilities) then
		return
	end
	if (capabilities["Interruptable"]) then
		Wheight = Wheight + 1
		AAP.BrutallCC.BrutallFrame.FS1:Show()
		AAP.BrutallCC.BrutallFrame.FS1:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,5)
	else
		AAP.BrutallCC.BrutallFrame.FS1:Hide()
	end
	if (capabilities["Stunable"]) then
		Wheight = Wheight + 1
		AAP.BrutallCC.BrutallFrame.FS2:Show()
		if (Wheight == 1) then
			AAP.BrutallCC.BrutallFrame.FS2:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,5)
		elseif (Wheight == 2) then
			AAP.BrutallCC.BrutallFrame.FS2:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,-15)
		end
	else
		AAP.BrutallCC.BrutallFrame.FS2:Hide()
	end
	if (capabilities["Fearable"]) then
		Wheight = Wheight + 1
		AAP.BrutallCC.BrutallFrame.FS3:Show()
		if (Wheight == 1) then
			AAP.BrutallCC.BrutallFrame.FS3:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,5)
		elseif (Wheight == 2) then
			AAP.BrutallCC.BrutallFrame.FS3:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,-15)
		elseif (Wheight == 3) then
			AAP.BrutallCC.BrutallFrame.FS3:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,-35)
		end
	else
		AAP.BrutallCC.BrutallFrame.FS3:Hide()
	end
	AAP.BrutallCC.BrutallFrame.Frame:SetHeight((20*Wheight)+5)

end
AAP.BrutallCC.BrutalCCList = AAP.Data.NPCSources.BrutalCCList


function AAP_BrutallPaintFunc()

AAP.BrutallCC.BrutallFrame.Frame = CreateFrame("frame", "AAP_BrutalFrames1", AAP.BrutallCC.BrutallFrame)
AAP.BrutallCC.BrutallFrame.Frame:SetWidth(120)
AAP.BrutallCC.BrutallFrame.Frame:SetHeight(65)
AAP.BrutallCC.BrutallFrame.Frame:SetPoint("TOPLEFT", AAP.BrutallCC.BrutallFrame, "TOPLEFT",0,0)
AAP.BrutallCC.BrutallFrame.Frame:SetBackdrop( { 
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
});
AAP.BrutallCC.BrutallFrame.Frame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		AAP.BrutallCC.BrutallFrame:StartMoving();
		AAP.BrutallCC.BrutallFrame.isMoving = true;
	end
end)
AAP.BrutallCC.BrutallFrame.Frame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and AAP.BrutallCC.BrutallFrame.isMoving then
		AAP.BrutallCC.BrutallFrame:StopMovingOrSizing();
		AAP.BrutallCC.BrutallFrame.isMoving = false;
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"] = AAP.BrutallCC.BrutallFrame:GetLeft()
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"] = AAP.BrutallCC.BrutallFrame:GetTop() - GetScreenHeight()
		AAP.BrutallCC.BrutallFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"])
	end
end)
AAP.BrutallCC.BrutallFrame.Frame:SetScript("OnHide", function(self)
	if ( AAP.BrutallCC.BrutallFrame.isMoving ) then
		AAP.BrutallCC.BrutallFrame:StopMovingOrSizing();
		AAP.BrutallCC.BrutallFrame.isMoving = false;
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"] = AAP.BrutallCC.BrutallFrame:GetLeft()
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"] = AAP.BrutallCC.BrutallFrame:GetTop() - GetScreenHeight()
		AAP.BrutallCC.BrutallFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"])
	end
end)
AAP.BrutallCC.BrutallFrame.FS1 = AAP.BrutallCC.BrutallFrame.Frame:CreateFontString("AAPBrutallsFS1","ARTWORK", "ChatFontNormal")
AAP.BrutallCC.BrutallFrame.FS1:SetParent(AAP.BrutallCC.BrutallFrame.Frame)
AAP.BrutallCC.BrutallFrame.FS1:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,5)
AAP.BrutallCC.BrutallFrame.FS1:SetWidth(120)
AAP.BrutallCC.BrutallFrame.FS1:SetHeight(38)
AAP.BrutallCC.BrutallFrame.FS1:SetJustifyH("LEFT")
AAP.BrutallCC.BrutallFrame.FS1:SetFontObject("GameFontNormalSmall")
AAP.BrutallCC.BrutallFrame.FS1:SetText("Interruptable")
AAP.BrutallCC.BrutallFrame.FS1:SetTextColor(0, 1, 0)

AAP.BrutallCC.BrutallFrame.FS2 = AAP.BrutallCC.BrutallFrame.Frame:CreateFontString("AAPBrutallsFS2","ARTWORK", "ChatFontNormal")
AAP.BrutallCC.BrutallFrame.FS2:SetParent(AAP.BrutallCC.BrutallFrame.Frame)
AAP.BrutallCC.BrutallFrame.FS2:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,-15)
AAP.BrutallCC.BrutallFrame.FS2:SetWidth(120)
AAP.BrutallCC.BrutallFrame.FS2:SetHeight(38)
AAP.BrutallCC.BrutallFrame.FS2:SetJustifyH("LEFT")
AAP.BrutallCC.BrutallFrame.FS2:SetFontObject("GameFontNormalSmall")
AAP.BrutallCC.BrutallFrame.FS2:SetText("Stunnable")
AAP.BrutallCC.BrutallFrame.FS2:SetTextColor(0, 1, 0)

AAP.BrutallCC.BrutallFrame.FS3 = AAP.BrutallCC.BrutallFrame.Frame:CreateFontString("AAPBrutallsFS3","ARTWORK", "ChatFontNormal")
AAP.BrutallCC.BrutallFrame.FS3:SetParent(AAP.BrutallCC.BrutallFrame.Frame)
AAP.BrutallCC.BrutallFrame.FS3:SetPoint("TOPLEFT",AAP.BrutallCC.BrutallFrame.Frame,"TOPLEFT",5,-35)
AAP.BrutallCC.BrutallFrame.FS3:SetWidth(120)
AAP.BrutallCC.BrutallFrame.FS3:SetHeight(38)
AAP.BrutallCC.BrutallFrame.FS3:SetJustifyH("LEFT")
AAP.BrutallCC.BrutallFrame.FS3:SetFontObject("GameFontNormalSmall")
AAP.BrutallCC.BrutallFrame.FS3:SetText("Fearable")
AAP.BrutallCC.BrutallFrame.FS3:SetTextColor(0, 1, 0)


AAP.BrutallCC.BrutallFrame.FrameName = CreateFrame("frame", "AAP_BrutalFrames2", AAP.BrutallCC.BrutallFrame)
AAP.BrutallCC.BrutallFrame.FrameName:SetWidth(170)
AAP.BrutallCC.BrutallFrame.FrameName:SetHeight(25)
AAP.BrutallCC.BrutallFrame.FrameName:SetPoint("TOP", AAP.BrutallCC.BrutallFrame.Frame, "TOP",-25,25)
AAP.BrutallCC.BrutallFrame.FrameName:SetBackdrop( { 
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
});
AAP.BrutallCC.BrutallFrame.FrameName:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		AAP.BrutallCC.BrutallFrame:StartMoving();
		AAP.BrutallCC.BrutallFrame.isMoving = true;
	end
end)
AAP.BrutallCC.BrutallFrame.FrameName:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and AAP.BrutallCC.BrutallFrame.isMoving then
		AAP.BrutallCC.BrutallFrame:StopMovingOrSizing();
		AAP.BrutallCC.BrutallFrame.isMoving = false;
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"] = AAP.BrutallCC.BrutallFrame:GetLeft()
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"] = AAP.BrutallCC.BrutallFrame:GetTop() - GetScreenHeight()
		AAP.BrutallCC.BrutallFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"])
	end
end)
AAP.BrutallCC.BrutallFrame.FrameName:SetScript("OnHide", function(self)
	if ( AAP.BrutallCC.BrutallFrame.isMoving ) then
		AAP.BrutallCC.BrutallFrame:StopMovingOrSizing();
		AAP.BrutallCC.BrutallFrame.isMoving = false;
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"] = AAP.BrutallCC.BrutallFrame:GetLeft()
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"] = AAP.BrutallCC.BrutallFrame:GetTop() - GetScreenHeight()
		AAP.BrutallCC.BrutallFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"])
	end
end)
AAP.BrutallCC.BrutallFrame.FS4 = AAP.BrutallCC.BrutallFrame.Frame:CreateFontString("AAPBrutallsFS4","ARTWORK", "ChatFontNormal")
AAP.BrutallCC.BrutallFrame.FS4:SetParent(AAP.BrutallCC.BrutallFrame.FrameName)
AAP.BrutallCC.BrutallFrame.FS4:SetPoint("LEFT",AAP.BrutallCC.BrutallFrame.FrameName,"LEFT",5,0)
AAP.BrutallCC.BrutallFrame.FS4:SetWidth(170)
AAP.BrutallCC.BrutallFrame.FS4:SetHeight(20)
AAP.BrutallCC.BrutallFrame.FS4:SetJustifyH("LEFT")
AAP.BrutallCC.BrutallFrame.FS4:SetFontObject("GameFontNormalSmall")
AAP.BrutallCC.BrutallFrame.FS4:SetText("Mob Name")
AAP.BrutallCC.BrutallFrame.FS4:SetTextColor(1, 1, 0)
AAP.BrutallCC.BrutallFrame.FrameName:Hide()
AAP.BrutallCC.BrutallFrame.Frame:Hide()
end

AAP.BrutallCC.BrutallEvents = CreateFrame("Frame")
AAP.BrutallCC.BrutallEvents:RegisterEvent ("ADDON_LOADED")
AAP.BrutallCC.BrutallEvents:RegisterEvent ("UPDATE_MOUSEOVER_UNIT")
AAP.BrutallCC.BrutallEvents:RegisterEvent ("PLAYER_TARGET_CHANGED")

AAP.BrutallCC.BrutallEvents:SetScript("OnEvent", function(self, event, ...)
	if (event=="UPDATE_MOUSEOVER_UNIT" and AAP_DisableAddon == 0) then
		if (UnitGUID("mouseover") and UnitName("mouseover")) then
			local guid, name = UnitGUID("mouseover"), UnitName("mouseover")
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
			if (type == "Creature" and npc_id and name) then
				if (UnitIsDead("mouseover") == false) then
					if (AAP.Data:NPCFor(tonumber(npc_id))) then
						AAP.BrutallCC.BrutallFrame.FS4:SetText(name)
						AAP.BrutallCC.Timer = 9
						AAP_BrutallShoFunc(tonumber(npc_id))
						AAP.BrutallCC.BrutallFrame.FrameName:Show()
						AAP.BrutallCC.BrutallFrame.Frame:Show()
						AAP_BrutallTimer1:Play()
					end
				end
			end
		end
	elseif (event=="ADDON_LOADED" and AAP_DisableAddon == 0) then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == "AAP-Core") then
			AAP_BrutallPaintFunc()
			AAP_BrutallTimer1 = AAP.BrutallCC.BrutallEvents:CreateAnimationGroup()
			AAP_BrutallTimer1.anim = AAP_BrutallTimer1:CreateAnimation()
			AAP_BrutallTimer1.anim:SetDuration(1)
			AAP_BrutallTimer1:SetLooping("REPEAT")
			AAP_BrutallTimer1:SetScript("OnLoop", function(self, event, ...)
				if (AAP.BrutallCC.TargetTimer == 0) then
					if (AAP.BrutallCC.Timer < 1) then
						AAP.BrutallCC.Timer = 0
						AAP.BrutallCC.BrutallFrame.FrameName:Hide()
						AAP.BrutallCC.BrutallFrame.Frame:Hide()
						AAP_BrutallTimer1:Stop()
					else
						AAP.BrutallCC.Timer = AAP.BrutallCC.Timer - 1
					end
				end
			end)
	if (not AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"]) then
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"] = GetScreenWidth() / 2.8
	end
	if (not AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"]) then
		AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"] = -(GetScreenHeight() / 3)
	end
	AAP.BrutallCC.BrutallFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutallleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Brutalltop"])

			AAP_BrutallTimer1:Play()
		end
	elseif (event=="PLAYER_TARGET_CHANGED" and AAP_DisableAddon == 0) then
		local guid, name = UnitGUID("target"), UnitName("target")
		AAP.BrutallCC.TargetTimer = 0
		if (guid) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
			if (npc_id) then
				if (UnitIsDead("target") == false) then
					if (AAP.Data:NPCFor(tonumber(npc_id))) then
						AAP.BrutallCC.BrutallFrame.FS4:SetText(name)
						AAP.BrutallCC.TargetTimer = 1
						AAP.BrutallCC.Timer = 9
						AAP_BrutallShoFunc(tonumber(npc_id))
						AAP.BrutallCC.BrutallFrame.FrameName:Show()
						AAP.BrutallCC.BrutallFrame.Frame:Show()
						AAP_BrutallTimer1:Play()
					end
				else
					AAP.BrutallCC.TargetTimer = 0
					AAP.BrutallCC.Timer = 0
				end
			end
		end
	end
end)