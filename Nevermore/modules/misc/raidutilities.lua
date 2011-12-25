--[[ 
		Raid utilities are loaded only if you are using Nevermore raid frames 
		All others raid frames mods or default Blizzard should have already this feature
--]]

local T, C, L = unpack(select(2, ...))
local panel_height = ((T.Scale(5)*4) + (T.Scale(22)*4))
local r,g,b = C["media"].backdropcolor
--Raid Utility by Elv22

if not (UnitInRaid("player") or (GetNumPartyMembers() > 0)) then return end
CompactRaidFrameManager:Kill() --Get rid of old module

local panel_height = ((T.Scale(5)*4) + (T.Scale(20)*4))

--Create main frame
local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", UIParent)
RaidUtilityPanel:CreatePanel("Default", NevermoreMinimap:GetWidth(), panel_height, "TOPRIGHT", NevermoreMinimap, "BOTTOMRIGHT", 0, -T.buttonspacing)
RaidUtilityPanel:SetFrameLevel(3)
RaidUtilityPanel:SetFrameStrata("MEDIUM")
RaidUtilityPanel.toggled = false

--Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((GetNumPartyMembers() > 0 and not UnitInRaid("player")) or IsRaidLeader() or IsRaidOfficer()) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end

		--Change border when mouse is inside the button
		local function ButtonEnter(self)

			local color = RAID_CLASS_COLORS[T.myclass]
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		end


		--Change border back to normal when mouse leaves button
		local function ButtonLeave(self)
			self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		end


-- Function to create buttons in this module
local function CreateButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text, texture)
	local b = CreateFrame("Button", name, parent, template)
	b:SetWidth(width)
	b:SetHeight(height)
	b:SetPoint(point, relativeto, point2, xOfs, yOfs)
	b:HookScript("OnEnter", ButtonEnter)
	b:HookScript("OnLeave", ButtonLeave)
	b:EnableMouse(true)
	b:SetTemplate("Default")
	if text then
		local t = b:CreateFontString(nil,"OVERLAY",b)
		t:SetFont(C["media"].font,12)
		t:SetPoint("CENTER")
		t:SetJustifyH("CENTER")
		t:SetText(text)
		b:SetFontString(t)
	elseif texture then
		local t = b:CreateTexture(nil,"OVERLAY",nil)
		t:SetTexture(texture)
		t:SetPoint("TOPLEFT", b, "TOPLEFT", T.mult, -T.mult)
		t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -T.mult, T.mult)
	end
end

--Show Button
CreateButton("ShowButton", UIParent, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", NevermoreMinimap:GetWidth(), 21, "TOPRIGHT", NevermoreMinimap, "BOTTOMRIGHT", 0, -T.buttonspacing, RAID_ASSISTANT, nil)
ShowButton:SetFrameRef("RaidUtilityPanel", RaidUtilityPanel)
ShowButton:SetAttribute("_onclick", [=[self:Hide(); self:GetFrameRef("RaidUtilityPanel"):Show();]=])
ShowButton:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = true end)

--Close Button
CreateButton("CloseButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", NevermoreMinimap:GetWidth(), 21, "TOP", RaidUtilityPanel, "BOTTOM", 0, -2, CLOSE, nil)
CloseButton:SetFrameRef("ShowButton", ShowButton)
CloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide(); self:GetFrameRef("ShowButton"):Show();]=])
CloseButton:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = false end)

--Disband Raid button
CreateButton("DisbandRaidButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, T.Scale(18), "TOP", RaidUtilityPanel, "TOP", 0, T.Scale(-5), "Disband Group", nil)
DisbandRaidButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		StaticPopup_Show("NevermoreDISBAND_RAID")
	end
end)

--Role Check button
CreateButton("RoleCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, T.Scale(18), "TOP", DisbandRaidButton, "BOTTOM", 0, T.Scale(-5), ROLE_POLL, nil)
RoleCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		InitiateRolePoll()
	end
end)

--MainTank Button
CreateButton("MainTankButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - T.Scale(2), T.Scale(18), "TOPLEFT", RoleCheckButton, "BOTTOMLEFT", 0, T.Scale(-5), MAINTANK, nil)
MainTankButton:SetAttribute("type", "maintank")
MainTankButton:SetAttribute("unit", "target")
MainTankButton:SetAttribute("action", "toggle")

--MainAssist Button
CreateButton("MainAssistButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - T.Scale(2), T.Scale(18), "TOPRIGHT", RoleCheckButton, "BOTTOMRIGHT", 0, T.Scale(-5), MAINASSIST, nil)
MainAssistButton:SetAttribute("type", "mainassist")
MainAssistButton:SetAttribute("unit", "target")
MainAssistButton:SetAttribute("action", "toggle")

--Ready Check button
CreateButton("ReadyCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RoleCheckButton:GetWidth() * 0.75, T.Scale(18), "TOPLEFT", MainTankButton, "BOTTOMLEFT", 0, T.Scale(-5), READY_CHECK, nil)
ReadyCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		DoReadyCheck()
	end
end)

--Reposition/Resize and Reuse the World Marker Button
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("TOPRIGHT", MainAssistButton, "BOTTOMRIGHT", 0, T.Scale(-5))
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent("RaidUtilityPanel")
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetHeight(T.Scale(18))
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(RoleCheckButton:GetWidth() * 0.22)

--Put other stuff back
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)

CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPLEFT", 0, 1)
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT", 0, 1)

--Reskin Stuff
do
	local buttons = {
		"CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton",
		"DisbandRaidButton",
		"MainTankButton",
		"MainAssistButton",
		"RoleCheckButton",
		"ReadyCheckButton",
		"ShowButton",
		"CloseButton"
	}

	for i, button in pairs(buttons) do
		local f = _G[button]
		_G[button.."Left"]:SetAlpha(0)
		_G[button.."Middle"]:SetAlpha(0)
		_G[button.."Right"]:SetAlpha(0)
		f:SetHighlightTexture("")
		f:SetDisabledTexture("")
		f:HookScript("OnEnter", ButtonEnter)
		f:HookScript("OnLeave", ButtonLeave)
		f:SetTemplate("Default", true)
	end
end

local function ToggleRaidUtil(self, event)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if CheckRaidStatus() then
		if RaidUtilityPanel.toggled == true then
			ShowButton:Hide()
			RaidUtilityPanel:Show()
		else
			ShowButton:Show()
			RaidUtilityPanel:Hide()
		end
	else
		ShowButton:Hide()
		RaidUtilityPanel:Hide()
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

--Automatically show/hide the frame if we have RaidLeader or RaidOfficer
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:RegisterEvent("PARTY_MEMBERS_CHANGED")
LeadershipCheck:SetScript("OnEvent", ToggleRaidUtil)
