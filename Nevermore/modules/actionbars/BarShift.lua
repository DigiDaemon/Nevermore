local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Shapeshift Bar
---------------------------------------------------------------------------

-- used for anchor totembar or shapeshiftbar
local NevermoreShift = CreateFrame("Frame","NevermoreShiftBar",NevermoreStance)
NevermoreShift:SetPoint("BOTTOM", 0, 0)
NevermoreShift:SetWidth(NevermoreStance:GetWidth())
NevermoreShift:SetHeight(NevermoreStance:GetHeight())
NevermoreShift:SetFrameStrata("MEDIUM")
NevermoreShift:SetMovable(true)
NevermoreShift:SetClampedToScreen(true)

-- shapeshift command to move totem or shapeshift in-game
local ssmover = CreateFrame("Frame", "NevermoreShapeShiftHolder", NevermoreStance)
ssmover:SetAllPoints(NevermoreStance)
ssmover:SetTemplate("Default")
ssmover:SetFrameStrata("HIGH")
ssmover:SetBackdropBorderColor(1,0,0)
ssmover:SetAlpha(0)
ssmover.text = T.SetFontString(ssmover, C.media.uffont, 12)
ssmover.text:SetPoint("CENTER")
ssmover.text:SetText(L.move_shapeshift)

-- hide it if not needed and stop executing code
if C.actionbar.hideshapeshift then NevermoreShift:Hide() return end

-- create the shapeshift bar if we enabled it
local bar = CreateFrame("Frame", "NevermoreShapeShift", NevermoreShift, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetAllPoints(NevermoreShift)

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
}

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			button:ClearAllPoints()
			button:SetParent(self)
			button:SetFrameStrata("LOW")
			if i == 1 then
				button:Point("BOTTOMLEFT", NevermoreShift, 0, T.buttonspacing)
			else
				local previous = _G["ShapeshiftButton"..i-1]
				button:Point("BOTTOM", previous, "TOP", 0, T.buttonspacing)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			end
		end
		RegisterStateDriver(self, "visibility", States[T.myclass] or "hide")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
		T.NevermoreShiftBarUpdate()
	elseif event == "PLAYER_ENTERING_WORLD" then
		T.StyleShift()
	else
		T.NevermoreShiftBarUpdate()
	end
end)
