local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local _, ns = ...
local oUF = ns.oUF or oUF or oUFTukui

if not C["unitframes"].enable == false then return end
if not oUF then return end
assert(oUF, "<name> was unable to locate oUF install.")

--[[
## Interface: 30200
## Title: |cffCC3333oUF|r|cff4f4f4f_ClassIcons
## Author: cogumel0
## Version: 1.0
## Dependencies: oUF
## Notes: oUF Class Icons support
]]--

local classIcons = {}
local Update = function(self, event)
	_, class = UnitClass(self.unit)
	local icon = self.ClassIcon
	local coords = classIcons[class]

	if(class) and UnitIsPlayer(self.unit) then
		icon:Show()
        icon:SetTexture("Interface\\AddOns\\Tukui_SUI\\medias\\icons\\"..class..".tga")
        if self.Portrait then
            self.Portrait:Hide()
        end;
	else
		icon:Hide()
        if self.Portrait then
            self.Portrait:Show()
        end;
	end
end

local Enable = function(self, event)
	local cicon = self.ClassIcon
	if(cicon) then
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Update)		
		return true
	end
end

local Disable = function(self)
	local ricon = self.ClassIcon
	if(ricon) then
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED", Update)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Update)
	end
end

oUF:AddElement('ClassIcon', Update, Enable, Disable)
