-- Combo Points for Nevermore 14+

local T, C, L = unpack(select(2, ...))
local parent = NevermoreTarget
local stick

if T.myclass == "ROGUE" and C.unitframes.movecombobar then
	parent = NevermorePlayer
	stick = true
end

if not parent or C.unitframes.classiccombo then return end

local shadow = parent.shadow
local buffs = parent.Buffs
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Colors = { 
	[1] = {.69, .31, .31, 1},
	[2] = {.65, .42, .31, 1},
	[3] = {.65, .63, .35, 1},
	[4] = {.46, .63, .35, 1},
	[5] = {.33, .63, .33, 1},
}

local function UpdateBuffs(self, points)
	if stick then return end
	
	if points and points > 0 then
		self:Show()
		
		-- update player frame shadow
		if shadow then
			shadow:Point("TOPLEFT", -4, 12)
		end
		
		-- update Y position of buffs
		if buffs then 
			buffs:ClearAllPoints() 
			buffs:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 14)
		end
	else
		self:Hide()
		
		-- update player frame shadow
		if shadow then
			shadow:Point("TOPLEFT", -4, 4)
		end
		
		-- update Y position of buffs
		if buffs then 
			buffs:ClearAllPoints() 
			buffs:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 4)
		end
	end
end

local function OnUpdate(self)
	local points
	
	if UnitHasVehicleUI("player") then
		points = GetComboPoints("vehicle", "target")
	else
		points = GetComboPoints("player", "target")
	end

	if points then
		-- update combos display
		for i = 1, MAX_COMBO_POINTS do
			if i <= points then
				self[i]:SetAlpha(1)
			else
				self[i]:SetAlpha(.2)
			end
		end
	end

	UpdateBuffs(self, points)
end

-- create the bar
local NevermoreCombo = CreateFrame("Frame", "NevermoreCombo", parent)
NevermoreCombo:Point("BOTTOMLEFT", parent, "TOPLEFT", 0, 1)
NevermoreCombo:SetWidth(parent:GetWidth())
NevermoreCombo:SetHeight(8)
NevermoreCombo:SetTemplate("Default")
NevermoreCombo:SetBackdropBorderColor(unpack(C.media.backdropcolor))
NevermoreCombo:RegisterEvent("PLAYER_ENTERING_WORLD")
NevermoreCombo:RegisterEvent("UNIT_COMBO_POINTS")
NevermoreCombo:RegisterEvent("PLAYER_TARGET_CHANGED")
NevermoreCombo:SetScript("OnEvent", OnUpdate)
NevermoreCombo:Show()

-- create combos
for i = 1, 5 do
	NevermoreCombo[i] = CreateFrame("StatusBar", "NevermoreComboBar"..i, NevermoreCombo)
	NevermoreCombo[i]:Height(8)
	NevermoreCombo[i]:SetStatusBarTexture(C.media.normTex)
	NevermoreCombo[i]:GetStatusBarTexture():SetHorizTile(false)
	NevermoreCombo[i]:SetFrameLevel(NevermoreCombo:GetFrameLevel() + 1)
	NevermoreCombo[i]:SetStatusBarColor(unpack(Colors[i]))
	
	if i == 1 then
		NevermoreCombo[i]:Point("LEFT", NevermoreCombo, "LEFT", 0, 0)
		NevermoreCombo[i]:Width(parent:GetWidth() / 5)
	else
		NevermoreCombo[i]:Point("LEFT", NevermoreCombo[i-1], "RIGHT", 1, 0)
		NevermoreCombo[i]:Width(parent:GetWidth() / 5 - 1)
	end
	
	if stick then
		shadow:Point("TOPLEFT", -4, 12)
	end
end
