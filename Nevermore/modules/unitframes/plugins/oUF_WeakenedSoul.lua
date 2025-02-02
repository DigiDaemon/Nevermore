local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local _, ns = ...
local oUF = ns.oUF or oUF or oUFTukui

if not C["unitframes"].enable == false then return end
if not oUF then return end
assert(oUF, "<name> was unable to locate oUF install.")

--[[
## Interface: 40000
## Title: |cffCC3333oUF|r|cff4f4f4f_WeakenedSoul
## Notes: Adds a status bar to watch Weakened Soul time left to oUF frames units.
## Author: Tukz
## Version: 1
## X-Category: oUF
## Dependencies: oUF
]]--

if select(2, UnitClass('player')) ~= "PRIEST" then return end

local function GetDebuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, 'HARMFUL')

		if spellId == 6788 then
			return true
		end

		i = i + 1
	until not spellId
end

local function UpdateBar(self, event, unit)
	local duration = self.dur
	local timeLeft = self.exp-GetTime()

	self:SetValue((timeLeft * 100) / duration)
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local ws = self.WeakenedSoul

	if ws.PreUpdate then ws:PreUpdate(unit) end

	if GetDebuffInfo(unit) then
		local _, _, _, _, _, duration, expirationTime = UnitDebuff(unit, GetSpellInfo(6788))
		ws.dur = duration
		ws.exp = expirationTime		
		ws:Show()
		ws:SetScript("OnUpdate", UpdateBar)
	else
		ws:Hide()
		ws:SetScript("OnUpdate", nil)
	end

	if ws.PostUpdate then ws:PostUpdate(unit) end
end

local function Enable(self)
	local ws = self.WeakenedSoul
	if ws then
		self:RegisterEvent("UNIT_AURA", Update)
		ws:SetMinMaxValues(0, 100)
		
		ws.unit = self.unit

		return true
	end
end

local function Disable(self)
	if self.WeakenedSoul then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

--oUF:AddElement('WeakenedSoul', Update, Enable, Disable)
