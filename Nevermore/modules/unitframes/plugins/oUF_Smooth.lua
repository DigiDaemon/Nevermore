local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local _, ns = ...
local oUF = ns.oUF or oUF or oUFTukui

if not C["unitframes"].enable == false then return end
if not oUF then return end
assert(oUF, "<name> was unable to locate oUF install.")

--[[
## Interface: 40100
## Title: |cffCC3333oUF|r|cff4f4f4f_SmoothUpdate
## Notes: Smoothly updates bars
## Author: Xuerian
## Version: 1.4
## X-Category: UnitFrame
## Dependencies: oUF
## DefaultState: enabled
## X-oUF: oUF
]]--

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(self, bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	end
end


for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)


local f, min, max = CreateFrame('Frame'), math.min, math.max 
f:SetScript('OnUpdate', function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)
