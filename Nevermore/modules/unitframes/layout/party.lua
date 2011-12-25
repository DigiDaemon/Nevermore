local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Nevermore was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["unitframes"].enable == true then return end

-----------------------------------------------------------------------------
-- the magic
-----------------------------------------------------------------------------
local function Shared(self, unit)
	self.colors = oUF_colors
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('type2', 'menu')
    
	self:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", insets = {top = -1, left = -1, bottom = -1, right = -1}})
	self:SetBackdropColor(C["general"].backdropcolor)    
-----------------------------------------------------------------------------
-- health
-----------------------------------------------------------------------------
    local health = CreateFrame('StatusBar', nil, self)
    health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetHeight(22)
	health:SetStatusBarTexture(C["media"].normTex)
    health:SetStatusBarColor(0,0,0)
    
    health.frequentUpdates = true
    health.colorDisconnected = false
    health.colorClass = false
    health.Smooth = true
	self.Health = health
-----------------------------------------------------------------------------
-- healthbackground
-----------------------------------------------------------------------------
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(C["media"].normTex)
	health.bg:SetVertexColor(.4,.4,.4)
	health.bg.multiplier = 0.3
    self.Health.bg = health.bg
-----------------------------------------------------------------------------
-- Panels
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Healthborder
-----------------------------------------------------------------------------
    local healthborder = CreateFrame("frame","healthborder",health)
    healthborder:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8", 
        edgeFile = "Interface\\Buttons\\WHITE8x8", 
        tile = false,
        tileSize = 0,
        edgeSize = 1, 
        insets = {
        left = -1,
        right = -1,
        top = -1,
        bottom = -1
        }
    });
    healthborder:SetBackdropColor(0, 0, 0, 1);
    healthborder:SetBackdropBorderColor(0.5, 0.5, 0.5);
    healthborder:SetPoint("TOPLEFT",-2,2)
    healthborder:SetPoint("BOTTOMRIGHT",2,-2)
    healthborder:SetBackdropColor(0,0,0,1)
    healthborder:SetFrameLevel(self:GetFrameLevel())
    healthborder:SetFrameStrata(self:GetFrameStrata())
-----------------------------------------------------------------------------
-- Panel at the bottom
-----------------------------------------------------------------------------
    self.Panel = CreateFrame("Frame", self:GetName().."Panel", health)
    self.Panel:SetPoint("TOP", health, "BOTTOM", 0, -1)
    self.Panel:SetSize(self:GetWidth()+4, 17)
    self.Panel:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8", 
        edgeFile = "Interface\\Buttons\\WHITE8x8", 
        tile = false,
        tileSize = 0,
        edgeSize = 1, 
        insets = {
        left = -1,
        right = -1,
        top = -1,
        bottom = -1
        }
    });
    self.Panel:SetBackdropColor(0, 0, 0, 1);
    self.Panel:SetBackdropBorderColor(0.5, 0.5, 0.5);
    self.Panel:SetFrameLevel(self:GetFrameLevel())
    self.Panel:SetFrameStrata(self:GetFrameStrata())
    
    local bg = self.Panel:CreateTexture(nil, 'BORDER')
    bg:SetPoint("TOPLEFT", 2, -2)
    bg:SetPoint("BOTTOMRIGHT", -2, 2)
    bg:SetTexture(C["media"].normTex);
    bg:SetVertexColor(0, 0, 0)

-----------------------------------------------------------------------------
-- Power
-----------------------------------------------------------------------------
	local power = CreateFrame('StatusBar', nil, self);
		power:SetStatusBarTexture(C["media"].normTex);
		power:SetHeight(self.Panel:GetHeight())
    		power:SetWidth( self.Panel:GetWidth() )
   		power:SetPoint("TOPLEFT", self.Panel, 2, -2)
		power:SetPoint("BOTTOMRIGHT", self.Panel, -2, 2)
		self.Power = power

-----------------------------------------------------------------------------
-- Power Background
-----------------------------------------------------------------------------
	local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power);
		powerBG:SetTexture(C["media"].normTex);
		powerBG.multiplier = 0.5
		self.Power.bg = powerBG

-----------------------------------------------------------------------------
-- Power functions
----------------------------------------------------------------------------- 
		power.frequentUpdates = 0.1 -- (for rogues and cats)
		power.Smooth = true 
		power.colorDisconnected = true
		power.colorClass = true
		power.colorClassNPC = false
		power.colorTapping = true	
-----------------------------------------------------------------------------
-- Leader
-----------------------------------------------------------------------------
	local Leader = self.Health:CreateTexture(nil, "OVERLAY")
		Leader:SetHeight(14);
		Leader:SetWidth(14);
		Leader:SetPoint("LEFT", power, "LEFT", 2, 2);
		self.Leader = Leader
-----------------------------------------------------------------------------
-- Targetborder
-----------------------------------------------------------------------------
    self.Border = CreateFrame("Frame", nil, self);
	self.Border:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		title = false,
		tileSize = 0,
		edgeSize = 1,
		insets = {
			left = -1,
			right = -1,
			top = -1,
			bottom = -1
		}
	})
	self.Border:SetPoint("TOPLEFT",-2,2);
	self.Border:SetPoint("BOTTOMRIGHT",2,0);
	self.Border:SetFrameStrata(self:GetFrameStrata());
	self.Border:SetFrameLevel(self:GetFrameLevel()+1);
	self.Border:SetBackdropBorderColor(0.31, 0.45, 0.63);
	self.Border:SetBackdropColor(0,0,0,0);
	self.Border:Hide();
-----------------------------------------------------------------------------
-- healthvalue
-----------------------------------------------------------------------------
--	health.value = SetFontString(health)
--	health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
--	health.PostUpdate = PostUpdateHealthRaid
-----------------------------------------------------------------------------
-- Role Icon
-----------------------------------------------------------------------------
	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetHeight(19)
	LFDRole:SetWidth(19)
	LFDRole:SetPoint("LEFT", 2, -1)
	LFDRole:Hide()
	self.LFDRole = LFDRole
-----------------------------------------------------------------------------
-- powervalue
-----------------------------------------------------------------------------
--	local power = CreateFrame("StatusBar", nil, self)
--	self.Power = power
--	power.value = SetFontString(health)
--	power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
--	power.PreUpdate = PreUpdatePower
--	power.PostUpdate = PostUpdatePower
-----------------------------------------------------------------------------
-- Name
-----------------------------------------------------------------------------
	local Name = T.SetFontString(health)
		Name:SetPoint("CENTER", self.Panel)
		Name:SetJustifyH("LEFT")
		Name:SetFont(C["media"].font, C["media"].fontsizenorm, C["media"].fonttnoutline);
		self:Tag(Name, '[getnamecolor][namesupershort][shortclassification] [level]')
		self.Name = Name
-----------------------------------------------------------------------------
-- Raidicons
-----------------------------------------------------------------------------
	local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(18)
		RaidIcon:SetWidth(18)
		RaidIcon:SetPoint('RIGHT', -2, -1)
		self.RaidIcon = RaidIcon
-----------------------------------------------------------------------------
-- Register targetchange
-----------------------------------------------------------------------------


	self:RegisterEvent("PLAYER_TARGET_CHANGED", function(self)
		if ( UnitIsUnit("target", self.unit) ) then
			self.Border:Show();
		else
			self.Border:Hide();
		end
	end);
-----------------------------------------------------------------------------
-- Debuffhighlight
-----------------------------------------------------------------------------	
	CreateHighlight(self)
-----------------------------------------------------------------------------
-- Range
-----------------------------------------------------------------------------
	local range = {insideAlpha = 1, outsideAlpha = 0.3}
		self.Range = range
-----------------------------------------------------------------------------
-- Healcomm
-----------------------------------------------------------------------------
	T.createHealComm(self)
-----------------------------------------------------------------------------
-- Aurawatch
-----------------------------------------------------------------------------

T.createAuraWatch(self)

    return self
end

oUF:RegisterStyle('Party', Shared)

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Nevermore" then
		for k,v in pairs(NevermoreDataPerChar) do
  			if k == "role" and v == "dps" then  -- Checks to see if we're dps
oUF:Factory(function(self)

oUF:SetActiveStyle("Party")	
	local iParty = self:SpawnHeader("iParty", nil, "custom [@raid6,exists] hide;show",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', (NevermoreInfo:GetWidth()/4) - (T.buttonspacing * 5.8),
        'initial-height', 40,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "yOffset", T.buttonspacing,
        "point", "BOTTOM",
        "groupFilter", "1",
        "groupingOrder", "1",
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 1,
        "columnSpacing", T.buttonspacing,
        "columnAnchorPoint", "LEFT"	
	)
	local GroupAnchor = CreateFrame("Frame", UIParent)
		GroupAnchor:SetHeight(300)
		GroupAnchor:SetWidth(500)
		GroupAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing) 
		iParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
	end)
end
  			if k == "role" and v == "heal" then -- Checks to see if we're heals		
oUF:Factory(function(self)

oUF:SetActiveStyle("Party")	
	local iParty = self:SpawnHeader("iParty", nil, "custom [@raid6,exists] hide;show",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', (NevermoreCenter:GetWidth()/4.35) - (T.buttonspacing * 6.98),
        'initial-height', 40,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "yOffset", T.buttonspacing,
        "point", "BOTTOM",
        "groupFilter", "1",
        "groupingOrder", "1",
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 1,
        "columnSpacing", T.buttonspacing * 2,
        "columnAnchorPoint", "LEFT"	
	)
	local GroupAnchor = CreateFrame("Frame", NevermoreCenter)
	GroupAnchor:SetHeight(300)
	GroupAnchor:SetWidth(NevermoreCenter:GetWidth())
	GroupAnchor:SetPoint("BOTTOMLEFT", NevermoreCenter, "TOPLEFT", T.buttonspacing, -(NevermoreCenter:GetHeight() + (iPlayer:GetHeight() * 1.5))) 
	iParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
end)


			end
			if k == "role" and v == "tank" then  -- Checks to see if we're tank
oUF:Factory(function(self)

oUF:SetActiveStyle("Party")	
	local iParty = self:SpawnHeader("iParty", nil, "custom [@raid6,exists] hide;show",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', (NevermoreInfo:GetWidth()/4) - (T.buttonspacing * 5.8),
        'initial-height', 40,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "yOffset", T.buttonspacing,
        "point", "BOTTOM",
        "groupFilter", "1",
        "groupingOrder", "1",
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 1,
        "columnSpacing", 3,
        "columnAnchorPoint", "LEFT"	
	)
	local GroupAnchor = CreateFrame("Frame", UIParent)
	GroupAnchor:SetHeight(300)
	GroupAnchor:SetWidth(500)
	GroupAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing) 
	iParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
end)

if (GetNumPartyMembers() > 0) then
	local tankmark = CreateFrame("Frame","NevermoreTankMark", UIParent)
	tankmark:SetHeight(T.buttonsize * 2)
	tankmark:SetTemplate("Default")
	tankmark:Point("BOTTOMLEFT", xprp, "TOPLEFT", 0, T.buttonsize * 1.35)
	tankmark:Point("BOTTOMRIGHT", xprp, "TOPRIGHT", 0, T.buttonsize * 1.35)

local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	if self == mark[i] then
	self:SetBackdropBorderColor(0, 0, 0, 0)
	else
	self:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end
 
local function ButtonLeave(self)
	if self == mark[i] then
	self:SetBackdropBorderColor(0, 0, 0, 0)
	else
	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
	end
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
	mark[i]:SetScript("OnEnter", ButtonEnter)
	mark[i]:SetScript("OnLeave", ButtonLeave)
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

else
end


 			end
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent);



