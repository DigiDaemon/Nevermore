local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local _, ns = ...
local oUF = ns.oUF or oUF or oUFTukui

--if not oUF then return end
-----------------------------------------------------------------------------
-- Level Color tag
-----------------------------------------------------------------------------
oUF.TagEvents['diffcolor'] = 'UNIT_LEVEL'
oUF.Tags['diffcolor'] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if (level < 1) then
		r, g, b = 0.69, 0.31, 0.31
	else
		local DiffColor = UnitLevel('target') - UnitLevel('player')
		if (DiffColor >= 5) then
			r, g, b = 0.69, 0.31, 0.31
		elseif (DiffColor >= 3) then
			r, g, b = 0.71, 0.43, 0.27
		elseif (DiffColor >= -2) then
			r, g, b = 0.84, 0.75, 0.65
		elseif (-DiffColor <= GetQuestGreenRange()) then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end
-----------------------------------------------------------------------------
-- ClassColor for Name tags
-----------------------------------------------------------------------------

oUF.Tags['getnamecolor'] = function(unit)
	local reaction = UnitReaction(unit, 'player')
	if (class == "PRIEST") then return end
	if (UnitIsPlayer(unit)) then
		return _TAGS['raidcolor'](unit)
	elseif (reaction) then
		local c = oUF.colors.reaction[reaction]
		return string.format('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = .84,.75,.65
		return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
	end
end
-----------------------------------------------------------------------------
-- Nametag with 5 letters
-----------------------------------------------------------------------------
oUF.TagEvents['namesupershort'] = 'UNIT_NAME_UPDATE'
oUF.Tags['namesupershort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 5, false)
end
-----------------------------------------------------------------------------
-- Nametag with 10 letters
-----------------------------------------------------------------------------
oUF.TagEvents['nameshort'] = 'UNIT_NAME_UPDATE'
oUF.Tags['nameshort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 10, false)
end
-----------------------------------------------------------------------------
-- Nametag with 15 letters
-----------------------------------------------------------------------------
oUF.TagEvents['namemedium'] = 'UNIT_NAME_UPDATE'
oUF.Tags['namemedium'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 15, false)
end
-----------------------------------------------------------------------------
-- Nametag with 20 letters
-----------------------------------------------------------------------------
oUF.TagEvents['namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags['namelong'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 20, true)
end
-----------------------------------------------------------------------------
-- Afk Tag
-----------------------------------------------------------------------------
oUF.TagEvents['afk'] = 'PLAYER_FLAGS_CHANGED'
oUF.Tags['afk'] = function(unit)
	if UnitIsAFK(unit) then
		return CHAT_FLAG_AFK
	end
end

-----------------------------------------------------------------------------
-- Threat Tag
-----------------------------------------------------------------------------
oUF.TagEvents['threat'] = 'UNIT_THREAT_LIST_UPDATE'
oUF.Tags['threat'] = function(unit)
	local tanking, status, percent = UnitDetailedThreatSituation('player', 'target')
	if(percent and percent > 0) then
		return ('%s%d%%|r'):format(Hex(GetThreatStatusColor(status)), percent)
	end
end
-----------------------------------------------------------------------------
-- Health percent tag
-----------------------------------------------------------------------------
oUF.TagEvents['healthperc'] = 'UNIT_HEALTH'
oUF.Tags['healthperc'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
    return ('|cffaf243a%d|r' --[['|cffaf243a%%|r']]):format(min / max * 100)
end
-----------------------------------------------------------------------------
-- Druid Mana Tag
-----------------------------------------------------------------------------
oUF.Tags['druid'] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	if(UnitPowerType(unit) ~= 0 and min ~= max) then
		return ('|cff0090ff%d%%|r'):format(min / max * 100)
	end
end
