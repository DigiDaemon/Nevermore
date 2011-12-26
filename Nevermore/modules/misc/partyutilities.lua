--[[ 
		Party utilities are loaded only if you are using Nevermore raid frames 
		All others raid frames mods or default Blizzard should have already this feature
--]]

local T, C, L = unpack(select(2, ...))

if (IsPartyLeader("player") or GetNumPartyMembers() > 0 ) then

	local tankmark = CreateFrame("Frame","NevermoreTankMark", UIParent)
	tankmark:SetHeight(T.buttonsize * 2)
	tankmark:SetTemplate("Default")
	tankmark:Point("BOTTOMLEFT", xprp, "TOPLEFT", 0, T.buttonsize * 1.35)
	tankmark:Point("BOTTOMRIGHT", xprp, "TOPRIGHT", 0, T.buttonsize * 1.35)

local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
 
local function ButtonLeave(self)
	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
end

local mark = CreateFrame("Button", "Menu", tankmark)
for i = 1, 8 do
	mark[i] = CreateFrame("Button", "mark"..i, tankmark)
	mark[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	mark[i]:CreatePanel("", T.buttonsize / 1.5, T.buttonsize / 1.5, "LEFT", tankmark, "LEFT", T.Scale(9), T.Scale(-3))
	if i == 1 then
		mark[i]:SetPoint("TOPLEFT", tankmark, "TOPLEFT",  9, -7)
		mark[i]:SetBackdropColor(0, 0, 0, 0);
    		mark[i]:SetBackdropBorderColor(0, 0, 0, 0);
	elseif i == 5 then
		mark[i]:SetPoint("TOP", mark[1], "BOTTOM", 3, -3)
		mark[i]:SetBackdropColor(0, 0, 0, 0);
    		mark[i]:SetBackdropBorderColor(0, 0, 0, 0);
	else
		mark[i]:SetPoint("LEFT", mark[i-1], "RIGHT", 5, 0)
		mark[i]:SetBackdropColor(0, 0, 0, 0);
    		mark[i]:SetBackdropBorderColor(0, 0, 0, 0);
	end
	mark[i]:EnableMouse(true)
	mark[i]:SetFrameStrata("HIGH")
	mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", i) end)
	
	-- Set up each button
	if i == 1 then 
		mark[i]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
	elseif i == 2 then
		mark[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
	elseif i == 3 then
		mark[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
	elseif i == 4 then
		mark[i]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
	elseif i == 5 then
		mark[i]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
	elseif i == 6 then
		mark[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
	elseif i == 7 then
		mark[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
	elseif i == 8 then
		mark[i]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

local ClearTargetButton = CreateFrame("Button", "ClearTargetButton", tankmark)
ClearTargetButton:CreatePanel("", T.buttonsize * 2.2, T.buttonsize / 1.5, "TOPLEFT", mark[4], "TOPRIGHT", 3, 0)
ClearTargetButton:SetTemplate("Default")
ClearTargetButton:SetScript("OnEnter", ButtonEnter)
ClearTargetButton:SetScript("OnLeave", ButtonLeave)
ClearTargetButton:SetScript("OnMouseUp", function() SetRaidTarget("target", 0) end)
ClearTargetButton:SetFrameStrata("HIGH")

ClearTargetButtonText = T.SetFontString(ClearTargetButton, C["media"].font, 12, C["media"].fonttnoutline)
ClearTargetButtonText:SetText("CLEAR")
ClearTargetButtonText:SetPoint("CENTER")
ClearTargetButtonText:SetJustifyH("CENTER", 0, 0)

local ToggleButton = CreateFrame("Frame", "ToggleButton", UIParent)
ToggleButton:CreatePanel("Default", 100, 20, "CENTER", UIParent, "CENTER", 0, 0)
ToggleButton:ClearAllPoints()
ToggleButton:Point("BOTTOMLEFT", xprp, "TOPLEFT", 0, T.buttonsize * 1.35)
ToggleButton:Point("BOTTOMRIGHT", xprp, "TOPRIGHT", 0, T.buttonsize * 1.35)
ToggleButton:EnableMouse(true)
ToggleButton:SetFrameStrata("HIGH")
ToggleButton:SetScript("OnEnter", ButtonEnter)
ToggleButton:SetScript("OnLeave", ButtonLeave)
ToggleButton:Hide()

local ToggleButtonText = T.SetFontString(ToggleButton, C["media"].font, 12, C["media"].fonttnoutline)
ToggleButtonText:SetText("MARK BAR")
ToggleButtonText:SetPoint("CENTER", ToggleButton, "CENTER")
	
--Create close button
local CloseButton = CreateFrame("BUTTON", "CloseButton", tankmark)
CloseButton:CreatePanel("Default", T.buttonsize * 2.2, T.buttonsize / 1.5, "TOPLEFT", mark[8], "TOPRIGHT", 3, 0)
CloseButton:EnableMouse(true)
CloseButton:SetScript("OnEnter", ButtonEnter)
CloseButton:SetScript("OnLeave", ButtonLeave)
CloseButton:SetFrameStrata("HIGH")
	
local CloseButtonText = T.SetFontString(CloseButton, C["media"].font, 12, C["media"].fonttnoutline)
CloseButtonText:SetText("HIDE")
CloseButtonText:SetPoint("CENTER", CloseButton, "CENTER")

	ToggleButton:SetScript("OnMouseDown", function()
		if tankmark:IsShown() then
			tankmark:Hide()
		else
			tankmark:Show()
			ToggleButton:Hide()
		end
	end)
	
	CloseButton:SetScript("OnMouseDown", function()
		if tankmark:IsShown() then
			tankmark:Hide()
			ToggleButton:Show()
		else
			ToggleButton:Show()
		end
	end)
end



--Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((GetNumPartyMembers() > 0 and not UnitInRaid("player")) or IsRaidLeader() or IsRaidOfficer()) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end




local function ToggleRaidUtil(self, event)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
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
