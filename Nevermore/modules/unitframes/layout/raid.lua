local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Nevermore was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["unitframes"].enable == true then return end

local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:Hide()
			CompactRaidFrameContainer:UnregisterAllEvents()
			CompactRaidFrameContainer:Hide()
end)

--if not oUF then return end
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
	self:SetBackdropColor(0,0,0)    
-----------------------------------------------------------------------------
-- health
-----------------------------------------------------------------------------
    local health = CreateFrame('StatusBar', nil, self)
    health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetHeight(28)
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
    healthborder:SetPoint("TOPLEFT", -2,2)
    healthborder:SetPoint("BOTTOMRIGHT",2,-2)
    healthborder:SetBackdropColor(0,0,0,1)
    healthborder:SetFrameLevel(self:GetFrameLevel())
    healthborder:SetFrameStrata(self:GetFrameStrata())
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
	self.Border:SetPoint("BOTTOMRIGHT",2,-2);
	self.Border:SetFrameStrata(self:GetFrameStrata());
	self.Border:SetFrameLevel(self:GetFrameLevel()+1);
	self.Border:SetBackdropBorderColor(0.5, 0.5, 0.5);
	self.Border:SetBackdropColor(0,0,0,0);
	self.Border:Hide();

-----------------------------------------------------------------------------
-- Power
-----------------------------------------------------------------------------
	local power = CreateFrame('StatusBar', nil, self);
		power:SetStatusBarTexture(C["media"].normTex);
		power:SetFrameLevel(health:GetFrameLevel() + 1);
		power:SetHeight(10)
		power:SetWidth( self:GetWidth() )
		power:SetPoint("BOTTOM", health, "BOTTOM", 0, 0 )
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
-- healthvalue
-----------------------------------------------------------------------------
	health.value = T.SetFontString(health)
	health.value:SetPoint("BOTTOM", powerBG, "BOTTOM", 0, 0);
	health.PostUpdate = PostUpdateHealthRaid
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
-- Name
-----------------------------------------------------------------------------
	local Name = SetFontString(health)
	Name:SetPoint("CENTER", health, "CENTER", 0, 5)
	self:Tag(Name, '[getnamecolor][namesupershort][shortclassification]')
	self.Name = Name
-----------------------------------------------------------------------------
-- Raidicons
-----------------------------------------------------------------------------
	local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetHeight(16)
	RaidIcon:SetWidth(16)
	RaidIcon:SetPoint("TOPLEFT", 0, -1)
	self.RaidIcon = RaidIcon
-----------------------------------------------------------------------------
-- Role Icon
-----------------------------------------------------------------------------
	LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetHeight(16)
	LFDRole:SetWidth(16)
	LFDRole:SetPoint("TOPRIGHT", 0, -1)
	LFDRole:Hide()
	self.LFDRole = LFDRole
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
	T.createHealComm(self, unit)
-----------------------------------------------------------------------------
-- Aurawatch
-----------------------------------------------------------------------------
	T.createAuraWatch(self)
    
	return self
end

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Nevermore" then
		for k,v in pairs(NevermoreDataPerChar) do
  			if k == "role" and v == "dps" then
oUF:RegisterStyle('Raid', Shared)
oUF:Factory(function(self)

	oUF:SetActiveStyle("Raid")	

	local iRaid = self:SpawnHeader("iRaid", nil, "custom [@raid6,exists] show;hide",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', ((NevermoreInfo:GetWidth()/4) - (T.buttonspacing * 6.5)),
        'initial-height', 28,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "xOffset", -7,
        "point", "RIGHT",
        "groupFilter", "1,2,3,4,5,6,7,8",
		'groupingOrder', '1,2,3,4,5,6,7,8',
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 5,
        "columnSpacing", 7,
        "columnAnchorPoint", "BOTTOM"	
	)
	local raidAnchor = CreateFrame("Frame", UIParent)
		raidAnchor:SetHeight(300)
		raidAnchor:SetWidth(500)
		raidAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing)    
		iRaid:SetPoint("TOPLEFT", raidAnchor, 0, 0)
	end)
			end
  			if k == "role" and v == "heal" then		
oUF:RegisterStyle('Raid', Shared)
oUF:Factory(function(self)

	oUF:SetActiveStyle("Raid")	

	local iRaid = self:SpawnHeader("iRaid", nil, "custom [@raid6,exists] show;hide",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', ((NevermoreInfo:GetWidth()/4) - (T.buttonspacing * 6.5)),
        'initial-height', 28,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "xOffset", -7,
        "point", "RIGHT",
        "groupFilter", "1,2,3,4,5,6,7,8",
		'groupingOrder', '1,2,3,4,5,6,7,8',
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 5,
        "columnSpacing", 7,
        "columnAnchorPoint", "BOTTOM"	
	)
	local raidAnchor = CreateFrame("Frame", UIParent)
		raidAnchor:SetHeight(300)
		raidAnchor:SetWidth(500)
		raidAnchor:SetPoint("BOTTOM", NevermoreCenter, "TOP", NevermoreCenter:GetWidth() /5.5, iPlayer:GetHeight() * 2)    
		iRaid:SetPoint("BOTTOMLEFT", raidAnchor, 0, 0)
	end)
			end
			if k == "role" and v == "tank" then
oUF:RegisterStyle('Raid', Shared)
oUF:Factory(function(self)

	oUF:SetActiveStyle("Raid")	

	local iRaid = self:SpawnHeader("iRaid", nil, "custom [@raid6,exists] show;hide",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', ((NevermoreInfo:GetWidth()/4) - (T.buttonspacing * 6.5)),
        'initial-height', 28,	
        "showParty", true,
        "showRaid", true,
        "showPlayer", true, 
        "showSolo", false,
        "xOffset", -7,
        "point", "RIGHT",
        "groupFilter", "1,2,3,4,5,6,7,8",
		'groupingOrder', '1,2,3,4,5,6,7,8',
        "groupBy", "GROUP",
        "maxColumns", 5,
        "unitsPerColumn", 5,
        "columnSpacing", 7,
        "columnAnchorPoint", "BOTTOM"	
	)
	local raidAnchor = CreateFrame("Frame", UIParent)
		raidAnchor:SetHeight(300)
		raidAnchor:SetWidth(500)
		raidAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing)    
		iRaid:SetPoint("TOPLEFT", raidAnchor, 0, 0)
	end)
 			end
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent);


