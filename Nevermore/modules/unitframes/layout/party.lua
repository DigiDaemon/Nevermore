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
		Leader:SetPoint("LEFT", power, "LEFT", 1, 1);
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
	local NeDParty = self:SpawnHeader("NeDParty", nil, "custom [@raid6,exists] hide;show",
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
		NeDParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
	end)
end
  			if k == "role" and v == "heal" then -- Checks to see if we're heals		
oUF:Factory(function(self)

oUF:SetActiveStyle("Party")	
	local NeHParty = self:SpawnHeader("NeHParty", nil, "custom [@raid6,exists] hide;show",
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
	NeHParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
end)


			end
			if k == "role" and v == "tank" then  -- Checks to see if we're tank
oUF:Factory(function(self)

oUF:SetActiveStyle("Party")	
	local NeTParty = self:SpawnHeader("NeTParty", nil, "custom [@raid6,exists] hide;show",
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
	NeTParty:SetPoint("TOPLEFT", GroupAnchor, 0, 0)
end)
 			end
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent);



