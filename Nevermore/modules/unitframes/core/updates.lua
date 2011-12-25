local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF or oUFTukui
--assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-----------------------------------------------------------------------------
-- Auratracker update
-----------------------------------------------------------------------------
function updateAuraTrackerTime(self, elapsed)
	if (self.active) then
		self.timeleft = self.timeleft - elapsed

		if (self.timeleft <= 5) then
			self.text:SetTextColor(1, 0, 0) -- red
		else
			self.text:SetTextColor(1, 1, 1) -- white
		end
		
		if (self.timeleft <= 0) then
			self.icon:SetTexture("")
			self.text:SetText("")
		end	
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end
-----------------------------------------------------------------------------
-- Raidhealth
-----------------------------------------------------------------------------
PostUpdateHealthRaid = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."off".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."ghost".."|r")
		end
	else
		local r, g, b
		if min ~= max then
			health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
		else
            health.value:SetText("|cff559655"..ShortValue(max).."|r")
		end
	end
end
-----------------------------------------------------------------------------
-- Health postUpdate
-----------------------------------------------------------------------------
PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."off".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."ghost".."|r")
		end
	else
		local r, g, b
		if min ~= max then
			local r, g, b
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5/|r |cff559655%s|r", ShortValue(min), ShortValue(max))
			elseif unit == "target" or unit == "focus" or (unit and unit:find("boss%d")) then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5/|r |cff559655%s|r", ShortValue(min), ShortValue(max))
			elseif (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(min).."|r")
			else
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			end
		else
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetText("|cff559655"..max.."|r")
			elseif unit == "target" or unit == "focus" or (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
end
-----------------------------------------------------------------------------
-- Power postUpdate
-----------------------------------------------------------------------------
PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.UnitColor.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

    if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
                    power.value:SetFormattedText("%s |cffD7BEA5/|r %s", ShortValue(max - (max - min)), ShortValue(max))
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
                    power.value:SetFormattedText("%s |cffD7BEA5/|r %s", ShortValue(max - (max - min)), ShortValue(max))
				elseif (unit and unit:find("arena%d")) then
					power.value:SetText(ShortValue(min))
				else
                    power.value:SetFormattedText("%s |cffD7BEA5/|r %s", ShortValue(max - (max - min)), ShortValue(max))
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) then
				power.value:SetText(ShortValue(min))
			else
				power.value:SetText(min)
			end
		end
    end
end
-----------------------------------------------------------------------------
-- Power preUpdate
-----------------------------------------------------------------------------
PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = T.UnitColor.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end
