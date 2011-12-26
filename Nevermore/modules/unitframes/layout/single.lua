local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Nevermore was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

if not C["unitframes"].enable == true then return end

local Layout = function(self, unit)
-----------------------------------------------------------------------------
-- General Settings Begin
-----------------------------------------------------------------------------

-- ***** Local Settings ***** --

_, class = UnitClass("player")

-----------------------------------------------------------------------------
-- Some cool functions
-----------------------------------------------------------------------------
	self.menu = menu
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetAttribute("*type2", "menu")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	menu(self)
-----------------------------------------------------------------------------
-- Health
-----------------------------------------------------------------------------    
	local health = CreateFrame('StatusBar', self:GetName().."_Health", self);
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(C["media"].normTex);
		health:SetStatusBarColor(0, 0, 0, 1);
		self.Health = health

-----------------------------------------------------------------------------
-- Health functions
----------------------------------------------------------------------------- 
		health.frequentUpdates = true
		health.Smooth = true
		health.colorTapping = false
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(0, 0, 0, 1);

-----------------------------------------------------------------------------
-- Health Background
----------------------------------------------------------------------------- 
	local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(139/255, 0, 0, 1);
		self.Health.bg = healthBG

-----------------------------------------------------------------------------
-- Power
-----------------------------------------------------------------------------
	local power = CreateFrame('StatusBar', nil, self);
		power:SetStatusBarTexture(C["media"].normTex);
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
-- Health Value
-----------------------------------------------------------------------------
		health.value = T.SetFontString(health);
		health.value:SetPoint("RIGHT", health, "RIGHT", -4, 0);
		health.PostUpdate = PostUpdateHealth

-----------------------------------------------------------------------------
-- Power Value
-----------------------------------------------------------------------------    
		power.value = T.SetFontString(health);
		power.value:SetPoint("LEFT", health, "LEFT", 4, 0);
		power.PreUpdate = PreUpdatePower
		power.PostUpdate = PostUpdatePower

-----------------------------------------------------------------------------
-- Name
----------------------------------------------------------------------------- 
	local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0);
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["media"].fontsizenorm, C["media"].fonttnoutline);
		self:Tag(Name, '[getnamecolor][nameshort] [diffcolor][level] [shortclassification]')
		self.Name = Name

-----------------------------------------------------------------------------
-- Masterloot
----------------------------------------------------------------------------- 
	local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
		MasterLooter:SetHeight(14);
		MasterLooter:SetWidth(14);
		MasterLooter:SetPoint("TOP",self,0,5);
		self.MasterLooter = MasterLooter

-----------------------------------------------------------------------------
-- Leader
-----------------------------------------------------------------------------
	local Leader = self.Health:CreateTexture(nil, "OVERLAY")
		Leader:SetHeight(14);
		Leader:SetWidth(14);
	if ( unit == "player" or unit == "target" or unit == "focus" ) then
		Leader:SetPoint("TOPLEFT", 2, 1);
	else
		Leader:SetPoint("TOPLEFT", 2, 1)
	end
		self.Leader = Leader

-----------------------------------------------------------------------------
-- PvP Icon
-----------------------------------------------------------------------------
	status = T.SetFontString(health)
	status:SetTextColor(0.69, 0.31, 0.31, 1)
	status:Hide()
	self:Tag(status, "[pvp]")
	self.Status = status

-----------------------------------------------------------------------------
-- Combat Icon
-----------------------------------------------------------------------------
	Combat = health:CreateTexture(nil, "OVERLAY")
	Combat:SetHeight(19)
	Combat:SetWidth(19)
	Combat:SetPoint("CENTER",0,1)
	Combat:SetVertexColor(0.69, 0.31, 0.31)
	Combat:Hide()
	self.Combat = Combat

-----------------------------------------------------------------------------
-- Role Icon
-----------------------------------------------------------------------------
	LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:SetHeight(19)
	LFDRole:SetWidth(19)
	LFDRole:SetPoint("TOPLEFT", 2, -2)
	LFDRole:Hide()
	self.LFDRole = LFDRole

-----------------------------------------------------------------------------
-- Phasing
-----------------------------------------------------------------------------
	PhaseIcon = self.Health:CreateTexture(nil, "OVERLAY")
	PhaseIcon:SetHeight(19)
	PhaseIcon:SetWidth(19)
	PhaseIcon:SetPoint("TOPLEFT",4,1)
	PhaseIcon:Hide()
	self.PhaseIcon = PhaseIcon

-----------------------------------------------------------------------------
-- Quest
-----------------------------------------------------------------------------
	QuestIcon = self.Health:CreateTexture(nil, "OVERLAY")
	QuestIcon:SetHeight(19)
	QuestIcon:SetWidth(19)
	QuestIcon:SetPoint("TOPLEFT",4,1)
	QuestIcon:Hide()
	self.QuestIcon = QuestIcon

-----------------------------------------------------------------------------
-- Raid Icon
-----------------------------------------------------------------------------
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	if ( unit == "player" or unit == "target" or unit == "focus" ) then
		RaidIcon:SetHeight(19)
		RaidIcon:SetWidth(19)
		RaidIcon:SetPoint("TOPRIGHT", -2, -2)
	elseif (unit == "target" and class == "ROGUE" ) then
		RaidIcon:SetHeight(19)
		RaidIcon:SetWidth(19)
		RaidIcon:SetPoint("TOPRIGHT", -15, -2)
	else
		RaidIcon:SetHeight(11)
		RaidIcon:SetWidth(11)
		RaidIcon:SetPoint("TOPRIGHT", -2, -1)
	end
	self.RaidIcon = RaidIcon

-----------------------------------------------------------------------------
-- Border
-----------------------------------------------------------------------------
	self.Border = CreateFrame("Frame", self:GetName().."Border", self)
	self.Border:SetPoint("TOPLEFT", -2, 2)
	self.Border:SetPoint("BOTTOMRIGHT", 2, -2)
	self.Border:SetBackdrop({
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
	self.Border:SetBackdropColor(0, 0, 0, 1);
	self.Border:SetBackdropBorderColor(0.5, 0.5, 0.5);
	self.Border:SetFrameStrata("BACKGROUND")
    
	if ( unit == "player" or unit == "target" or unit == "focus" ) and ( class == "PRIEST" ) then
		local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
			ws:SetAllPoints(self.Power)
			ws:SetStatusBarTexture(C["media"].normTex)
			ws:GetStatusBarTexture():SetHorizTile(false)
			ws:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8x8", 
				tile = false,
				tileSize = 0,
				insets = {
					left = 0,
					right = 0,
					top = 0,
					bottom = 0
				}
			});
			ws:SetBackdropColor(0.1, 0.1, 0.1)
			ws:SetStatusBarColor(191/255, 10/255, 10/255)
			self.WeakenedSoul = ws
		end;
-----------------------------------------------------------------------------
-- General Settings End
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Target Begin
----------------------------------------------------------------------------- 
if ( unit == "target" ) then

    self:SetWidth(230)
    health:SetHeight(22)
            
    power:SetHeight(6)  
            
    self:SetHeight( health:GetHeight() + power:GetHeight() + 1 )
            
    self.Panel = CreateFrame("Frame", self:GetName().."Panel", self)
    self.Panel:SetPoint("TOP", self, "BOTTOM", 0, -1)
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
    self.Panel:SetFrameStrata("BACKGROUND")
            
    health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
    power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
    Name:SetPoint("CENTER", self.Panel)
            
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
		power:SetHeight(6)
    		power:SetWidth( self:GetWidth() )
		power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )
		
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
-- Power Value
-----------------------------------------------------------------------------    
		power.value = T.SetFontString(health);
		power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
		power.PreUpdate = PreUpdatePower
		power.PostUpdate = PostUpdatePower
            
local healthperc = health:CreateFontString(nil, "OVERLAY")
    healthperc:SetPoint("CENTER", health, "CENTER", 0, 0);
    healthperc:SetJustifyH("LEFT")
    healthperc:SetFont(C["media"].font, 20, C["media"].fonttnoutline);
	self:Tag(healthperc, '[healthperc]')
	self.healthperc = healthperc

-- ***** Target Combo Points ***** --
		
local cpoints = self.Health:CreateFontString(nil, 'OVERLAY')
	cpoints:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
	cpoints:SetFont(C["media"].font, 20, C["media"].fonttnoutline)
	cpoints:SetTextColor(1, 1, 1, 1)
	self:Tag(cpoints, '[cpoints]')

-- ***** Target Auras ***** --

local buffs = CreateFrame("Frame", nil, self);
local debuffs = CreateFrame("Frame", nil, self);
                    
    buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", T.buttonspacing, T.buttonspacing + 2);
    buffs:SetHeight(26);
    buffs:SetWidth(230);
    buffs.size = 22
    buffs.num = 10

    debuffs:SetHeight(26);
    debuffs:SetWidth(230);
    debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 0, 0);
    debuffs.size = 22
    debuffs.num = 8

	buffs.spacing = 3
    buffs.PostCreateIcon = T.PostCreateAura
    buffs.PostUpdateIcon = T.PostUpdateAura
    self.Buffs = buffs	

    debuffs.spacing = 3
    debuffs["growth-y"] = "UP"
    debuffs["growth-x"] = "RIGHT"
    debuffs.onlyShowPlayer = false -- true or false
    debuffs.PostCreateIcon = T.PostCreateAura
    debuffs.PostUpdateIcon = T.PostUpdateAura
    self.Debuffs = debuffs        

-- ***** Target Castbar ***** --
  
local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self);
    castbar:SetStatusBarTexture(C["media"].normTex);
    castbar:SetFrameLevel(9);
    castbar:SetFrameStrata("HIGH")
    castbar:SetPoint("TOP", iTargetPanel, "BOTTOM",0, -2);
    castbar:SetSize(iPlayer:GetWidth(), 10)
    castbar:SetStatusBarColor(0.2, 0.2, 0.2)
        
    castbar.time = T.SetFontString(castbar);
    castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0);
    castbar.time:SetTextColor(0.84, 0.75, 0.65);
    castbar.time:SetJustifyH("RIGHT")

    castbar.Text = T.SetFontString(castbar);
    castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0);
    castbar.Text:SetTextColor(0.84, 0.75, 0.65);
        
local SafeZone = castbar:CreateTexture(nil, "OVERLAY")
    SafeZone:SetTexture(C["media"].normTex)
    SafeZone:SetVertexColor(139/255, 0, 0, 1)
        
    self.Castbar = castbar
    self.Castbar.Time = castbar.time
    self.Castbar.SafeZone = SafeZone
        
    CastbarBorder = CreateFrame("Frame", self:GetName().."Border", castbar)
    CastbarBorder:SetPoint("TOPLEFT", -2, 2)
    CastbarBorder:SetPoint("BOTTOMRIGHT", 2, -2)
    CastbarBorder:SetBackdrop({
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
    CastbarBorder:SetBackdropColor(0, 0, 0, 1);
    CastbarBorder:SetBackdropBorderColor(0.5, 0.5, 0.5);
    CastbarBorder:SetFrameStrata("BACKGROUND")
        
local bg = CastbarBorder:CreateTexture(nil, 'OVERLAY')
    bg:SetPoint("TOPLEFT", 2, -2)
    bg:SetPoint("BOTTOMRIGHT", -2, 2)
    bg:SetTexture(C["media"].normTex);
    bg:SetVertexColor(0, 0, 0)
end;
-----------------------------------------------------------------------------
-- Target End
----------------------------------------------------------------------------- 
-----------------------------------------------------------------------------
-- Player Begin
----------------------------------------------------------------------------- 
if ( unit == "player" ) then
    Combat:Show()
    status:Show()
    Name:Show()
        
    self:SetWidth(230)
	power:SetHeight(6)
    health:SetHeight(22)
       
    self:SetHeight( health:GetHeight() + power:GetHeight() + 1 )
        
    self.Panel = CreateFrame("Frame", self:GetName().."Panel", self)
    self.Panel:SetPoint("TOP", self, "BOTTOM", 0, -1)
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
    self.Panel:SetFrameStrata("BACKGROUND")
        
    health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
    power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
    status:SetPoint("CENTER", self.Panel, 0, 0)

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
		power:SetHeight(6)
    		power:SetWidth( self:GetWidth() )
		power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )
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
-- Power Value
-----------------------------------------------------------------------------    
		power.value = T.SetFontString(health);
		power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
		power.PreUpdate = PreUpdatePower
		power.PostUpdate = PostUpdatePower

-- ***** Player Castbar ***** --
   
local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
	castbar:SetStatusBarTexture(C["media"].normTex);
       	castbar:SetFrameStrata("HIGH")
       	castbar:SetPoint("TOP", iPlayerPanel, "BOTTOM",0, 0);
       	castbar:SetSize(iPlayer:GetWidth(), 10)
       	castbar:SetStatusBarColor(0, 0, 1, 1)
		castbar:SetFrameLevel(10)
		
	CastbarBorder = CreateFrame("Frame", self:GetName().."Border", castbar)
   	CastbarBorder:SetPoint("TOPLEFT", -2, 2)
       	CastbarBorder:SetPoint("BOTTOMRIGHT", 2, -2)
       	CastbarBorder:SetBackdrop({
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
        	CastbarBorder:SetBackdropColor(0, 0, 0, 1);
        	CastbarBorder:SetBackdropBorderColor(0.5, 0.5, 0.5);
        	CastbarBorder:SetFrameStrata("BACKGROUND")
		
	castbar.bg = CastbarBorder:CreateTexture(nil, 'OVERLAY')
        castbar.bg:SetPoint("TOPLEFT", 2, -2)
        castbar.bg:SetPoint("BOTTOMRIGHT", -2, 2)
        castbar.bg:SetTexture(C["media"].normTex);
        castbar.bg:SetVertexColor(0.1, 0.1, 0.1)
		
	castbar.time = T.SetFontString(castbar);
   	castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0);
   	castbar.time:SetTextColor(0.84, 0.75, 0.65);
   	castbar.time:SetJustifyH("RIGHT")

	castbar.Text = T.SetFontString(castbar);
   	castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0);
   	castbar.Text:SetTextColor(0.84, 0.75, 0.65);
			
	SafeZone = castbar:CreateTexture(nil, "OVERLAY")
   	SafeZone:SetTexture(C["media"].normTex)
   	SafeZone:SetVertexColor(0.84, 0, 0, .5)

castbar.CustomDelayText = T.CustomCastDelayText
castbar.PostCastStart = T.CheckCast
castbar.PostChannelStart = T.CheckChannel
									
self.Castbar = castbar
self.Castbar.Time = castbar.time
self.Castbar.SafeZone = SafeZone

-- ***** Player Eclipse Bar ***** --
local tree = GetPrimaryTalentTree()
if unit == "player" and class == "DRUID" and tree == 1 then

        local EclipseBar = CreateFrame('Frame', nil, self)
        EclipseBar:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
        EclipseBar:SetSize(iPlayer:GetWidth(), 10)
        EclipseBar:SetTemplate("Default")
        
        local EclipseBarBorder = CreateFrame('Frame', nil, EclipseBar)
        EclipseBarBorder:SetAllPoints(EclipseBar)
        EclipseBarBorder:SetFrameLevel(EclipseBar:GetFrameLevel() + 2)

        local LunarBar = CreateFrame('StatusBar', nil, EclipseBar)
        LunarBar:SetPoint('LEFT', EclipseBar, 'LEFT', 2, 0)
        LunarBar:SetSize(iPlayer:GetWidth() - 4, 6)
        LunarBar:SetStatusBarTexture(C["media"].normTex)
        LunarBar:SetStatusBarColor(.5, 0, .5)
        EclipseBar.LunarBar = LunarBar

        local SolarBar = CreateFrame('StatusBar', nil, EclipseBar)
        SolarBar:SetPoint('LEFT', LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
        SolarBar:SetSize(iPlayer:GetWidth() - 4, 6)
        SolarBar:SetStatusBarTexture(C["media"].normTex)
        SolarBar:SetStatusBarColor(222/255,184/255,135/255)
        EclipseBar.SolarBar = SolarBar

        local EclipseBarText = EclipseBarBorder:CreateFontString(nil, 'OVERLAY')
        EclipseBarText:SetPoint('CENTER', EclipseBarBorder, 'CENTER', 0, 0)
        EclipseBarText:SetFont(C["media"].font, 12, C["media"].fonttnoutline);
        self:Tag(EclipseBarText, '[pereclipse]%')

        self.EclipseBar = EclipseBar

end

-- ***** Player Holy Power ***** --

if unit == "player" and class == "PALADIN" then
	local hpb = {}
			for i = 1, 3 do
				hpb[i] = CreateFrame('Frame', nil, self)
				hpb[i]:SetTemplate("Default")
				if i == 1 then
					hpb[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
				else
					hpb[i]:SetPoint("LEFT", hpb[i-1], "RIGHT", 1, 0)
				end
				hpb[i]:SetTemplate("Default")
				hpb[i]:SetSize(iPlayer:GetWidth()/3, 10)
			end
	self.HolyPower = CreateFrame("Frame", nil, self)
	self.HolyPower:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
	self.HolyPower:SetHeight(10)
	self.HolyPower:SetWidth(iPlayer:GetWidth())
	for i = 1, 3 do
		self.HolyPower[i] = CreateFrame("StatusBar", nil, self)
		self.HolyPower[i]:SetStatusBarTexture(C["media"].normTex)
		self.HolyPower[i]:SetStatusBarColor(222/255,184/255,135/255)
		self.HolyPower[i]:SetHeight(6)
		self.HolyPower[i]:SetWidth(iPlayer:GetWidth()/3 - 4)
			self.HolyPower[i]:SetBackdropColor(0.5, 0.5, 0.5, 1)
		if i == 1 then
			self.HolyPower[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 7)
		else
			self.HolyPower[i]:SetPoint("LEFT", self.HolyPower[i-1], "RIGHT", 5, 0)
		end
		self.HolyPower[i].bg = self.HolyPower[i]:CreateTexture(nil, "BORDER")
		self.HolyPower[i].bg:SetAllPoints(self.HolyPower[i])
		self.HolyPower[i].bg:SetTexture(C["media"].normTex)
		self.HolyPower[i].bg.multiplier = 0.3
	end
end

-- ***** Player Shards ***** --

if unit == "player" and class == "WARLOCK" then
	local ssb = {}
			for i = 1, 3 do
				ssb[i] = CreateFrame('Frame', nil, self)
				ssb[i]:SetTemplate("Default")
				if i == 1 then
					ssb[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
				else
					ssb[i]:SetPoint("LEFT", ssb[i-1], "RIGHT", 1, 0)
				end
				ssb[i]:SetTemplate("Default")
				ssb[i]:SetSize(iPlayer:GetWidth()/3, 10)
			end
	self.SoulShards = CreateFrame("Frame", nil, self)
	self.SoulShards:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
	self.SoulShards:SetHeight(10)
	self.SoulShards:SetWidth(iPlayer:GetWidth())
	for i = 1, 3 do
		self.SoulShards[i] = CreateFrame("StatusBar", nil, self)
		self.SoulShards[i]:SetStatusBarTexture(C["media"].normTex)
		self.SoulShards[i]:SetStatusBarColor(0.5, 0, 0.5, 1)
		self.SoulShards[i]:SetHeight(6)
		self.SoulShards[i]:SetWidth(iPlayer:GetWidth()/3 - 4)
			self.SoulShards[i]:SetBackdropColor(0.5, 0.5, 0.5, 1)
		if i == 1 then
			self.SoulShards[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 7)
		else
			self.SoulShards[i]:SetPoint("LEFT", self.SoulShards[i-1], "RIGHT", 5, 0)
		end
		self.SoulShards[i].bg = self.SoulShards[i]:CreateTexture(nil, "BORDER")
		self.SoulShards[i].bg:SetAllPoints(self.SoulShards[i])
		self.SoulShards[i].bg:SetTexture(C["media"].normTex)
		self.SoulShards[i].bg.multiplier = 0.3
	end

end

-- ***** Player Totems ***** --

if unit == "player" and class == "SHAMAN" then
			local tbb = {}
			for i = 1, 4 do
				tbb[i] = CreateFrame('Frame', nil, self)
				tbb[i]:SetTemplate("Default")
				if i == 1 then
					tbb[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
				else
					tbb[i]:SetPoint("LEFT", tbb[i-1], "RIGHT", 1, 0)
				end
				tbb[i]:SetTemplate("Default")
				tbb[i]:SetSize(iPlayer:GetWidth()/4 , 10)
			end

			local tb = {
				AbbreviateNames = true,
				Destroy = true,
				UpdateColors = true,
			}
			for i = 1, 4 do
				tb[i] = CreateFrame('Frame', nil, self)
				tb[i]:SetTemplate("Default")
				if i == 1 then
					tb[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
				else
					tb[i]:SetPoint("LEFT", tb[i-1], "RIGHT", 1, 0)
				end
				tb[i]:SetTemplate("Default")
				tb[i]:SetSize(iPlayer:GetWidth()/4 , 10)
				
				local bg = tb[i]:CreateTexture(nil, 'BACKGROUND')
				bg:SetAllPoints(tb[i])
				bg:SetTexture(1, 1, 1)
				bg.multiplier = 0.2
				tb[i].bg = bg
				
				local bar = CreateFrame('StatusBar', nil, tb[i])
				bar:SetPoint('RIGHT', -1, 0)
				bar:SetSize(iPlayer:GetWidth()/4 - 3, 8)
				bar.Reverse = false
				tb[i].StatusBar = bar
			end
			self.TotemBar = tb
		end

-- ***** Player Runes ***** --

if unit == "player" and class == "DEATHKNIGHT" then
	local rbb = {}
			for i = 1, 6 do
				rbb[i] = CreateFrame('Frame', nil, self)
				rbb[i]:SetTemplate("Default")
				if i == 1 then
					rbb[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
				else
					rbb[i]:SetPoint("LEFT", rbb[i-1], "RIGHT", 1, 0)
				end
				rbb[i]:SetTemplate("Default")
				rbb[i]:SetSize(iPlayer:GetWidth()/6, 10)
			end
	self.Runes = CreateFrame("Frame", nil, self)
	self.Runes:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 5)
	self.Runes:SetHeight(10)
	self.Runes:SetWidth(iPlayer:GetWidth())
	for i = 1, 6 do
		self.Runes[i] = CreateFrame("StatusBar", nil, self)
		self.Runes[i]:SetStatusBarTexture(C["media"].normTex)
		self.Runes[i]:SetStatusBarColor(0.5, 0, 0.5, 1)
		self.Runes[i]:SetHeight(6)
		self.Runes[i]:SetWidth(iPlayer:GetWidth()/6 - 4)
			self.Runes[i]:SetBackdropColor(0.5, 0.5, 0.5, 1)
		if i == 1 then
			self.Runes[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 7)
		else
			self.Runes[i]:SetPoint("LEFT", self.Runes[i-1], "RIGHT", 5, 0)
		end
		self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
		self.Runes[i].bg:SetAllPoints(self.Runes[i])
		self.Runes[i].bg:SetTexture(C["media"].normTex)
		self.Runes[i].bg.multiplier = 0.3
	end
end
end
-----------------------------------------------------------------------------
-- Player End
----------------------------------------------------------------------------- 
-----------------------------------------------------------------------------
-- Experience and Reputation Begin
-----------------------------------------------------------------------------
if ( unit == "player" ) then
self.xprp = CreateFrame("Frame", "xprp", self)
        self.xprp:Point("TOPLEFT", iPlayerPanel, "TOPRIGHT", T.buttonspacing, 0)
	self.xprp:Point("RIGHT", NevermoreCenter, "RIGHT", -(iPlayer:GetWidth() + (T.buttonspacing * 2.5)), 0)
        self.xprp:SetSize(iPlayer:GetWidth(), 30)
        self.xprp:SetBackdrop({
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
        self.xprp:SetBackdropColor(0, 0, 0, 1);
        self.xprp:SetBackdropBorderColor(0.5, 0.5, 0.5);
        self.xprp:SetFrameStrata("BACKGROUND")
	self.xprp:Show()

if T.level ~= MAX_PLAYER_LEVEL then


local Experience = CreateFrame("StatusBar", nil, self)
				Experience:SetStatusBarTexture(C["media"].normTex)
				Experience:SetStatusBarColor(0, 0, 1, 1)
				Experience:Width(xprp:GetWidth() - 4)
				Experience:Height(xprp:GetHeight()/2-3)
				Experience:Point("TOPLEFT", xprp, "TOPLEFT", 2, -2)
				Experience:Point("TOPRIGHT", xprp, "TOPRIGHT", -2, 2)
				Experience:SetFrameLevel(10)
				Experience.Tooltip = true
				Experience:EnableMouse()

				

				Experience.Text = Experience:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
				Experience.Text:SetFont(C["media"].font, 12)
				Experience.Text:SetPoint('CENTER', Experience, 0, 0)
			
				local Value = Experience:CreateFontString(nil, 'OVERLAY')
				Value:SetAllPoints(Experience)
				Value:SetFontObject(GameFontHighlight)

				self:Tag(Value, '[curshortxp] / [maxshortxp] - [perxp]% XP')
		
				Experience.Rested = CreateFrame('StatusBar', nil, Experience)
				Experience.Rested:SetAllPoints(Experience)
				Experience.Rested:SetFrameLevel(9)
				Experience.Rested:SetStatusBarTexture(C["media"].normTex)
				Experience.Rested:SetStatusBarColor(1, 0, 1, 0)

				local Resting = Experience:CreateTexture(nil, "OVERLAY")
				Resting:SetHeight(26)
				Resting:SetWidth(26)
				Resting:SetPoint("LEFT", -3, -5)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)

				local Rested = CreateFrame('StatusBar', nil, Experience)
				Rested:SetAllPoints(Experience)
				Rested:SetStatusBarTexture(C["media"].normTex)
				Rested:SetStatusBarColor(1, 0, 0.3)

				local function GetXP()
					return UnitXP(unit), UnitXPMax(unit), GetXPExhaustion()
				end

				local function SetTooltip()
					local unit = self:GetParent().unit
					local min, max = GetXP(unit)
					local rested = GetXPExhaustion()
					local restmin = 0
					local restmax = GetXPExhaustion()
					local bars = unit == 'pet' and 6 or 20

					GameTooltip:SetOwner(NevermoreTooltipAnchor, 'ANCHOR_NONE', 0, -5)
					GameTooltip:AddLine(string.format(XP..": %d / %d (%d%% - %d/%d)", min, max, min/max * 100, bars - (bars * (max - min) / max), bars))
					GameTooltip:AddLine(string.format(LEVEL_ABBR..": %d (%d%% - %d/%d)", max - min, (max - min) / max * 100, 1 + bars * (max - min) / max, bars))

					if(rested) then
						GameTooltip:AddLine(string.format("|cff0090ff"..TUTORIAL_TITLE26..": +%d (%d%%)", rested, (rested / max * 100)))
					end

					GameTooltip:Show()
				end

				function GameTooltip_Hide()
  					GameTooltip:Hide()
				end

				Experience:SetScript('OnLeave', GameTooltip_Hide)
				Experience:SetScript('OnEnter', SetTooltip)

				self.Experience = Experience
				self.Experience.Rested = Rested
				self.Experience.PostUpdate = ExperiencePostUpdate
end
if T.level == MAX_PLAYER_LEVEL then
				local ExperienceMax = CreateFrame("Frame", self:GetName().."_Experience", self)
				ExperienceMax:SetBackdrop(backdrop)
				ExperienceMax:SetBackdropColor(C["media"].backdropcolor)
				ExperienceMax:Width(xprp:GetWidth() - 4)
				ExperienceMax:Height(xprp:GetHeight()/2-3)
				ExperienceMax:Point("TOPLEFT", xprp, "TOPLEFT", 2, -2)
				ExperienceMax:Point("TOPRIGHT", xprp, "TOPRIGHT", -2, 2)
				ExperienceMax:SetFrameLevel(10)	
				ExperienceMax.Text = ExperienceMax:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
				ExperienceMax.Text:SetFont(C["media"].font, 12)
				ExperienceMax.Text:SetPoint('CENTER',ExperienceMax, 0, 0)
				ExperienceMax.Text:SetText("|cffFFFFFFMAX LEVEL|r")

			end

if T.level <= MAX_PLAYER_LEVEL then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(C["media"].normTex)
				Reputation:SetStatusBarColor(0.3, 0.3, 0.3, 1)
				Reputation:SetBackdrop(backdrop)
				Reputation:SetBackdropColor(0, 0, 0, 0)
				Reputation:SetBackdropBorderColor(0, 0, 0, 0)
				Reputation:Width(xprp:GetWidth()-3)
				Reputation:Height(xprp:GetHeight()/2-3)
				Reputation:Point('BOTTOMLEFT', xprp, 'BOTTOMLEFT', 1, 1)
				Reputation:Point('BOTTOMRIGHT', xprp, 'BOTTOMRIGHT', -1, 1)
				Reputation:SetFrameLevel(10)
				Reputation:SetAlpha(1)				
				Reputation.Tooltip = true
				Reputation.colorStanding = true
				Reputation.Text = Reputation:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
				Reputation.Text:SetFont(C["media"].font, 12)
				Reputation.Text:SetPoint('BOTTOM', Reputation, "BOTTOM", 0, -1)

				local function tooltip(self)
				local name, id, min, max, value = GetWatchedFactionInfo()
					GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, -5)
					GameTooltip:AddLine(string.format('%s (%s)', name, _G['FACTION_STANDING_LABEL'..id]))
					GameTooltip:AddLine(string.format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
					GameTooltip:Show()
				end


			Reputation:SetScript('OnLeave', GameTooltip_Hide)
			Reputation:SetScript('OnEnter', tooltip)
			local Value = Reputation:CreateFontString(nil, 'OVERLAY')
				Value:SetAllPoints(Reputation)
				Value:SetFontObject(GameFontHighlight)
				self:Tag(Value, '[currep] / [maxrep] - [reputation]')
						
				Reputation.Border = CreateFrame('Frame', nil, Reputation)
				Reputation.Border:SetAllPoints(Reputation)
				Reputation.Border:SetFrameLevel(Reputation:GetFrameLevel() + 5)
				self.Reputation = Reputation
			end
end
-----------------------------------------------------------------------------
-- Experience and Reputation End
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Target of Target Begin
-----------------------------------------------------------------------------   
    if unit == "targettarget" then
        power:Hide()
        power.value:Hide()
        health.value:Hide()
        
        self:SetWidth(xprp:GetWidth() - (T.buttonsize * 2) - (T.buttonspacing * 3))
        self:SetHeight(13)

        health:SetWidth(self:GetWidth())
        health:SetHeight(self:GetHeight())
        
        self:Tag(Name, '[getnamecolor][namemedium]')
    end;
-----------------------------------------------------------------------------
-- Target of Target End
----------------------------------------------------------------------------- 
-----------------------------------------------------------------------------
-- Focus Begin
-----------------------------------------------------------------------------
    if unit == "focus" then
    
        self:SetWidth(230)
        health:SetHeight(22)
        
        power:SetHeight(6)
        power:SetWidth( self:GetWidth() )
        power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )   
        
        self:SetHeight( health:GetHeight() + power:GetHeight() + 1 )
        
        self.Panel = CreateFrame("Frame", self:GetName().."Panel", self)
        self.Panel:SetPoint("TOP", self, "BOTTOM", 0, -1)
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
        self.Panel:SetFrameStrata("BACKGROUND")
        
        health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
        power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
        Name:SetPoint("CENTER", self.Panel)
        
        local bg = self.Panel:CreateTexture(nil, 'BORDER')
        bg:SetPoint("TOPLEFT", 2, -2)
        bg:SetPoint("BOTTOMRIGHT", -2, 2)
        bg:SetTexture(C["media"].normTex);
        bg:SetVertexColor(0.1, 0.1, 0.1)
        
        local healthperc = health:CreateFontString(nil, "OVERLAY")
        healthperc:SetPoint("CENTER", health, "CENTER", 0, 0);
        healthperc:SetJustifyH("LEFT")
        healthperc:SetFont(C["media"].font, 20, C["media"].fonttnoutline);
        self:Tag(healthperc, '[healthperc]')
        self.healthperc = healthperc

    end;
-----------------------------------------------------------------------------
-- Focus End
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Pet Begin
-----------------------------------------------------------------------------
    if unit == "pet" then
        --power.value:Hide()
        health.value:Hide()
        
        self:SetWidth(xprp:GetWidth() - (T.buttonsize * 2) - (T.buttonspacing * 3))
        health:SetHeight(12)
        --power:SetHeight(1)
        --power:SetWidth( self:GetWidth() )
        --power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )   
        self:SetHeight( health:GetHeight())
        --power.colorHappiness = true
        
        self:Tag(Name, '[getnamecolor][namemedium]')
    end;
-----------------------------------------------------------------------------
-- Pet End
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Arena Begin
----------------------------------------------------------------------------- 
    if (unit and unit:find("arena%d")) then
        self:SetWidth(230)
        health:SetHeight(22)
        
        power:SetHeight(8)
        power:SetWidth( self:GetWidth() )
        power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )   
        
        self:SetHeight( health:GetHeight() + power:GetHeight() + 1 )
        self.Panel = CreateFrame("Frame", self:GetName().."Panel", self)
        self.Panel:SetPoint("TOP", self, "BOTTOM", 0, -1)
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
        self.Panel:SetFrameStrata("BACKGROUND")
        
        health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
        power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
        Name:SetPoint("CENTER", self.Panel)
        
        local bg = self.Panel:CreateTexture(nil, 'BORDER')
        bg:SetPoint("TOPLEFT", 2, -2)
        bg:SetPoint("BOTTOMRIGHT", -2, 2)
        bg:SetTexture(C["media"].normTex);
        bg:SetVertexColor(0.1, 0.1, 0.1)

-- ***** Arena Talents ***** --

        self.Talents = T.SetFontString(self.Health, C["media"].font, 14, "THINOUTLINE")
        self.Talents:SetTextColor(1,0,0)
        self.Talents:SetPoint("BOTTOM", self.Health, 0, -2)

-- ***** Arena Auras ***** --

		local debuffs = CreateFrame("Frame", nil, self);
		debuffs:SetHeight(26);
		debuffs:SetWidth(200);
		debuffs:SetPoint('LEFT', self, 'RIGHT', 5, 0);
		debuffs.size = 26
		debuffs.num = 5
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
        debuffs["growth-x"] = "RIGHT"
        debuffs["growth-y"] = "DOWN"
        debuffs.onlyShowPlayer = false
        self.Debuffs = debuffs	

-- ***** Arena Class Icons ***** --

        local class = self:CreateTexture(nil, "OVERLAY")
	class:SetHeight(20)
	class:SetWidth(20)
        class:SetPoint("TOPLEFT", iTargetBorder, -1, 1)
        class:SetPoint("BOTTOMRIGHT", iTargetBorder, 1, -1)
        self.ClassIcon = class

-- ***** Arena Castbar ***** --
       
        local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self);
        castbar:SetStatusBarTexture(C["media"].normTex);
        castbar:SetFrameLevel(9);
        castbar:SetFrameStrata("HIGH")
        castbar:SetPoint("TOPLEFT",self.Panel,2,-2);		
        castbar:SetPoint("BOTTOMRIGHT",self.Panel,-2,2);
        castbar:SetStatusBarColor(0.2, 0.2, 0.2)
        
        castbar.time = T.SetFontString(castbar);
        castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -4, 1);
        castbar.time:SetTextColor(0.84, 0.75, 0.65);
        castbar.time:SetJustifyH("RIGHT")

        castbar.Text = T.SetFontString(castbar);
        castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 1);

        castbar.Text:SetTextColor(0.84, 0.75, 0.65);
        
        local bg = castbar:CreateTexture(nil, 'BORDER')
        bg:SetPoint("TOPLEFT", 2, -2)
        bg:SetPoint("BOTTOMRIGHT", -2, 2)
        bg:SetTexture(C["media"].normTex);
        bg:SetVertexColor(0.1, 0.1, 0.1)
        
        self.Castbar = castbar
        self.Castbar.Time = castbar.time
    end;
-----------------------------------------------------------------------------
-- Arena End
----------------------------------------------------------------------------- 

-----------------------------------------------------------------------------
-- Boss Begin
----------------------------------------------------------------------------- 
    if (unit and unit:find("boss%d")) then
        self:SetWidth(230)
        health:SetHeight(22)
        
        power:SetHeight(8)
        power:SetWidth( self:GetWidth() )
        power:SetPoint("BOTTOM", health, 0, - power:GetHeight() - 1 )   
        
        self:SetHeight( health:GetHeight() + power:GetHeight() + 1 )
        self.Panel = CreateFrame("Frame", self:GetName().."Panel", self)
        self.Panel:SetPoint("TOP", self, "BOTTOM", 0, -1)
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
        self.Panel:SetFrameStrata("BACKGROUND")
        
        health.value:SetPoint("RIGHT", self.Panel, "RIGHT", -4, 0);
        power.value:SetPoint("LEFT", self.Panel, "LEFT", 4, 0);
        Name:SetPoint("CENTER", self.Panel)
        
        local bg = self.Panel:CreateTexture(nil, 'BORDER')
        bg:SetPoint("TOPLEFT", 2, -2)
        bg:SetPoint("BOTTOMRIGHT", -2, 2)
        bg:SetTexture(C["media"].normTex);
        bg:SetVertexColor(0.1, 0.1, 0.1)

-- ***** Boss Castbar ***** --
     
        local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self);
        castbar:SetStatusBarTexture(C["media"].normTex);
        castbar:SetFrameLevel(9);
        castbar:SetFrameStrata("HIGH")
        castbar:SetPoint("TOPLEFT",self.Panel,2,-2);		
        castbar:SetPoint("BOTTOMRIGHT",self.Panel,-2,2);
        castbar:SetStatusBarColor(0.2, 0.2, 0.2)
        
        castbar.time = T.SetFontString(castbar);
        castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -4, 1);
        castbar.time:SetTextColor(0.84, 0.75, 0.65);
        castbar.time:SetJustifyH("RIGHT")

        castbar.Text = T.SetFontString(castbar);
        castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 1);
        castbar.Text:SetTextColor(0.84, 0.75, 0.65);
        
        local bg = castbar:CreateTexture(nil, 'BORDER')
        bg:SetPoint("TOPLEFT", 2, -2)
        bg:SetPoint("BOTTOMRIGHT", -2, 2)
        bg:SetTexture(C["media"].normTex);
        bg:SetVertexColor(0.1, 0.1, 0.1)
        
        self.Castbar = castbar
        self.Castbar.Time = castbar.time
    end;
-----------------------------------------------------------------------------
-- Boss End
----------------------------------------------------------------------------- 
	
-----------------------------------------------------------------------------
-- Debuffhighlight
-----------------------------------------------------------------------------	
	T.createHealComm(self)	
	T.createAuraWatch(self, unit) 
	CreateHighlight(self)
    
    return self
end	-- end of function

oUF:RegisterStyle('Nevermore', Layout)
oUF:SetActiveStyle('Nevermore')

oUF:Spawn('player', 'iPlayer'):SetPoint("TOPLEFT", NevermoreCenter, "TOPLEFT", T.buttonspacing , -T.buttonspacing)
oUF:Spawn('target', 'iTarget'):SetPoint("TOPRIGHT", NevermoreCenter, "TOPRIGHT", - T.buttonspacing, -T.buttonspacing)
oUF:Spawn('targettarget', 'iTargetTarget'):SetPoint("TOP", NevermoreCenter, "TOP", 0, -T.buttonspacing)
oUF:Spawn('pet', 'iPet'):SetPoint('TOP',iTargetTarget,'BOTTOM', 0, -T.buttonspacing)

if class == "DEATHKNIGHT" or class == "DRUID" or class == "SHAMAN" or class == "WARLOCK" or class == "PALADIN" then
	oUF:Spawn('focus', 'iFocus'):SetPoint('BOTTOM', iPlayer, 'TOP', 0, 34)
else
	oUF:Spawn('focus', 'iFocus'):SetPoint('BOTTOM', iPlayer, 'TOP', 0, 23)
end


iFocus:SetMovable(true)
iFocus:RegisterForDrag('LeftButton')
iFocus:SetUserPlaced(false)
iFocus:SetScript('OnDragStart', function(self)
    if (IsShiftKeyDown()) then
        self:StartMoving() 
    end
end)
iFocus:SetScript('OnDragStop', function(self) 
    self:StopMovingOrSizing()
end)

local arena = {}
for i = 1, 5 do
    arena[i] = oUF:Spawn("arena"..i, "iArena"..i);
    if i == 1 then
        arena[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 352, 411);
    else
        arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 25);
    end;
end;

local boss = {}
for i = 1, 5 do
    boss[i] = oUF:Spawn("boss"..i, "iBoss"..i);
    if i == 1 then
        boss[i]:SetPoint("LEFT", UIParent, "LEFT", 10, 0);
    else
        boss[i]:SetPoint("BOTTOM", boss[i-1], "TOP", 0, 25);
    end;
end;
