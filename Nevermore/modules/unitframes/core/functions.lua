local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Nevermore was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

if not C["unitframes"].enable == true then return end


function CreateHealComm(self)    
    local mhpb = CreateFrame('StatusBar', nil, self.Health)
    mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
    mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
    mhpb:SetWidth(150)
    mhpb:SetStatusBarTexture(unitframeconfig["Statusbar Texture"])
    mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

    local ohpb = CreateFrame('StatusBar', nil, self.Health)
    ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
    ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
    ohpb:SetWidth(150)
    ohpb:SetStatusBarTexture(unitframeconfig["Statusbar Texture"])
    ohpb:SetStatusBarColor(0, 1, 0, 0.25)

    self.HealPrediction = {
        myBar = mhpb,
        otherBar = ohpb,
        maxOverflow = 1,
    }
    return
end;
-----------------------------------------------------------------------------
-- debuffhighlight
-----------------------------------------------------------------------------
function CreateHighlight(self)
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
    return
end;
-----------------------------------------------------------------------------
-- aura and debuff watch
-----------------------------------------------------------------------------
function CreateWatch(self)

    createAuraWatch(self,unit)	
    
    local RaidDebuffs = CreateFrame('Frame', nil, self)
    RaidDebuffs:SetHeight(22)
    RaidDebuffs:SetWidth(22)
    RaidDebuffs:SetPoint('CENTER', self.Health, 1,0)
    RaidDebuffs:SetFrameStrata(self.Health:GetFrameStrata())
    RaidDebuffs:SetFrameLevel(self.Health:GetFrameLevel() + 2)
    RaidDebuffs:SetBackdrop({
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
    RaidDebuffs:SetBackdropColor(0, 0, 0, 1);
    RaidDebuffs:SetBackdropBorderColor(0.2, 0.2, 0.2);

    RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
    RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
    RaidDebuffs.icon:SetPoint("TOPLEFT", 2, -2)
    RaidDebuffs.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    
    RaidDebuffs.cd = CreateFrame('Cooldown', nil, RaidDebuffs)
    RaidDebuffs.cd:SetPoint("TOPLEFT", 2, -2)
    RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", -2, 2)
    RaidDebuffs.cd.noOCC = true -- remove this line if you want cooldown number on it

    RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
    RaidDebuffs.count:SetFont(unitframeconfig["Font"], 9, "THINOUTLINE")
    RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
    RaidDebuffs.count:SetTextColor(1, .9, 0)
    
    self.RaidDebuffs = RaidDebuffs
    
    return
end;
-----------------------------------------------------------------------------
-- Cut Values
-----------------------------------------------------------------------------
ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end
ShortValueNegative = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end
-----------------------------------------------------------------------------
-- Dropdown Menu
-----------------------------------------------------------------------------
function menu(self)
	local dropdown = _G[string.format('%sFrameDropDown', string.gsub(self.unit, '(.)', string.upper, 1))]
	if dropdown then
		ToggleDropDownMenu(1, nil, dropdown, 'cursor')
	elseif (self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G[format('PartyMemberFrame%dDropDown', self.id)], 'cursor')
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
	end
end
-----------------------------------------------------------------------------
-- Cut Name function
-----------------------------------------------------------------------------
utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end
-----------------------------------------------------------------------------
-- Fontstring
-----------------------------------------------------------------------------
SetFontString = function(parent)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetJustifyH("LEFT")
	fs:SetFont(unitframeconfig["Font"], unitframeconfig["Font size"], unitframeconfig["Font style"])
	fs:SetShadowColor(0, 0, 0, 1)
	fs:SetShadowOffset(0, 0)
	return fs
end
-----------------------------------------------------------------------------
-- Aura create
-----------------------------------------------------------------------------
local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end
local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(0.99, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

function PostCreateAura(element, button)
    button:SetBackdrop({
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
    button:SetBackdropBorderColor(0.2, 0.2, 0.2);
    button:SetBackdropColor(0, 0, 0)
	
	button.remaining = SetFontString(button)
	button.remaining:SetPoint("CENTER", 0, 0)
	
	button.cd.noOCC = true		 	    -- hide OmniCC CDs
	button.cd.noCooldownCount = true    -- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:SetPoint("TOPLEFT", 2, -2)
	button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count = SetFontString(button)
	button.count:SetPoint("BOTTOMRIGHT", 3, 1.5)
	button.count:SetTextColor(0.84, 0.75, 0.65)

	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)
end

function PostUpdateAura(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
    
	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(0.2, 0.2, 0.2) -- Border Color
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			icon.icon:SetDesaturated(false)
		end
	end

	if duration and duration > 0 then
        icon.remaining:Show()
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
end
