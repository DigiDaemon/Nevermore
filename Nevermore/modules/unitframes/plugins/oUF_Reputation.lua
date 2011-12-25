local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C.unitframes.enable ~= true then return end
--[[

	Elements handled:
	 .Reputation [statusbar]
	 .Reputation.Text [fontstring] (optional)

	Booleans:
	 - Tooltip

	Functions that can be overridden from within a layout:
	 - PostUpdate(self, event, unit, bar, min, max, value, name, id)
	 - OverrideText(bar, min, max, value, name, id)

--]]
local _, ns = ...
local oUF = ns.oUF or oUF

if not oUF then return end

local function tooltip(self)
	local name, id, min, max, value = GetWatchedFactionInfo()
	GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, -5)
	GameTooltip:AddLine(string.format('%s (%s)', name, _G['FACTION_STANDING_LABEL'..id]))
	GameTooltip:AddLine(string.format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
	GameTooltip:Show()
end

local function Update(self, event, unit)
	local reputation = self.Reputation

	local name, standing, min, max, value = GetWatchedFactionInfo()
	if(not name) then
		return reputation:Hide()
	else
		reputation:Show()
	end

	reputation:SetMinMaxValues(0, max - min)
	reputation:SetValue(value - min)

	if(reputation.colorStanding) then
		local color = FACTION_BAR_COLORS[standing]
		reputation:SetStatusBarColor(color.r, color.g, color.b)
	end

	if(reputation.PostUpdate) then
		return reputation:PostUpdate(unit, name, standing, min, max, value)
	end
end

local function Path(self, ...)
	return (self.Reputation.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local reputation = self.Reputation
	if(reputation) then
		reputation.__owner = self
		reputation.ForceUpdate = ForceUpdate

		self:RegisterEvent('UPDATE_FACTION', Path)

		if(not reputation:GetStatusBarTexture()) then
			reputation:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		return true
	end
end

local function Disable(self)
	if(self.Reputation) then
		self:UnregisterEvent('UPDATE_FACTION', Path)
	end
end

oUF:AddElement('Reputation', Path, Enable, Disable)
