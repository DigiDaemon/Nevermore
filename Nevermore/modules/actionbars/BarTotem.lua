local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C["actionbar"].enable ~= true then return end

-- we just use default totem bar for shaman
-- we parent it to our shapeshift bar.
-- This is approx the same script as it was in WOTLK Nevermore version.

-- ***** Move Totem Frame ***** --
if T.myclass == "SHAMAN" then
	local MiniTotem = CreateFrame("Frame","MiniTotem",UIParent)
		MiniTotem:SetWidth(NevermoreStance:GetWidth())
		MiniTotem:SetHeight(NevermoreStance:GetHeight())	
		MiniTotem:SetPoint("BOTTOMRIGHT", NevermoreStance, "BOTTOMRIGHT", 0, 0)
		MiniTotem:SetMovable(false)
		MultiCastActionBarFrame:SetParent(MiniTotem)
		MultiCastActionBarFrame:SetWidth(0.01)
		MultiCastSummonSpellButton:SetParent(MiniTotem)
		MultiCastSummonSpellButton:ClearAllPoints()
		MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT", MiniTotem, 0, 0)
	MiniTotem:Show()

for i=1, 4 do
	_G["MultiCastSlotButton"..i]:SetParent(MiniTotem)
end

MultiCastSlotButton1:ClearAllPoints()
MultiCastSlotButton1:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", -(T.buttonsize + T.buttonspacing), 0)
for i=2, 4 do
	local b = _G["MultiCastSlotButton"..i]
	local b2 = _G["MultiCastSlotButton"..i-1]
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", b2, "BOTTOMRIGHT", T.buttonspacing, 0)
end
		
MultiCastRecallSpellButton:ClearAllPoints()
MultiCastRecallSpellButton:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 0, spacing)
		
for i=1, 12 do
	local b = _G["MultiCastActionButton"..i]
	local b2 = _G["MultiCastSlotButton"..(i % 4 == 0 and 4 or i % 4)]
	b:ClearAllPoints()
	b:SetPoint("CENTER", b2, "CENTER", 0, 0)
end
		
local dummy = function() return end
for i=1, 4 do
	local b = _G["MultiCastSlotButton"..i]
	b.SetParent 	= dummy
	b.SetPoint 	= dummy
end
MultiCastRecallSpellButton.SetParent 	= dummy
MultiCastRecallSpellButton.SetPoint 	= dummy

local defaults = { Anchor = "CENTER", X = 0, Y = 0, Scale = 1.0, Hide = false }

local TotemTimers = {};
TotemTimers[1] = CreateFrame("Cooldown","TotemTimers1",MultiCastSlotButton1)
TotemTimers[2] = CreateFrame("Cooldown","TotemTimers2",MultiCastSlotButton2)
TotemTimers[3] = CreateFrame("Cooldown","TotemTimers3",MultiCastSlotButton3)
TotemTimers[4] = CreateFrame("Cooldown","TotemTimers4",MultiCastSlotButton4)
TotemTimers[1]:SetAllPoints(MultiCastSlotButton1)
TotemTimers[2]:SetAllPoints(MultiCastSlotButton2)
TotemTimers[3]:SetAllPoints(MultiCastSlotButton3)
TotemTimers[4]:SetAllPoints(MultiCastSlotButton4)

MiniTotem:RegisterEvent("VARIABLES_LOADED")
MiniTotem:RegisterEvent("PLAYER_ENTERING_WORLD")
MiniTotem:RegisterEvent("PLAYER_TOTEM_UPDATE")

MiniTotem:SetScript("OnEvent", function(self,event,...)
if (event=="PLAYER_ENTERING_WORLD") then
		if HasMultiCastActionBar() == false then
			MiniTotem:Hide()
		else
			MiniTotem:Show()
		end
		for i=1, MAX_TOTEMS do
			MiniTotem_Update(i)
		end
	elseif (event=="PLAYER_TOTEM_UPDATE") then
                MiniTotem_Update(select(1,...))
        end
end)


function MiniTotem_Destroy(self, button)
	if (button ~= "RightButton") then return end
	if (self:GetName() == "MultiCastActionButton1") or (self:GetName() == "MultiCastActionButton5") or (self:GetName() == "MultiCastActionButton9") then
		DestroyTotem(2);
	elseif (self:GetName() == "MultiCastActionButton2") or (self:GetName() == "MultiCastActionButton6") or (self:GetName() == "MultiCastActionButton10") then
		DestroyTotem(1);
	elseif (self:GetName() == "MultiCastActionButton3") or (self:GetName() == "MultiCastActionButton7") or (self:GetName() == "MultiCastActionButton11") then
		DestroyTotem(3);
	elseif (self:GetName() == "MultiCastActionButton4") or (self:GetName() == "MultiCastActionButton8") or (self:GetName() == "MultiCastActionButton12") then
		DestroyTotem(4);
	end
end

for i = 1, 12 do
	hooker = _G["MultiCastActionButton"..i];
	hooker:HookScript("OnClick", MiniTotem_Destroy)
end

	MiniTotem:SetPoint("BOTTOMRIGHT", NevermoreStance, "BOTTOMRIGHT", 0, 0)
	
function MiniTotem_Update(totemN)
	if BlizzardTimers == false then
		TotemFrame:Hide()
	end
	if MiniTotemTimers == true then
		haveTotem, totemName, startTime, duration = GetTotemInfo(totemN)
       		if (duration == 0) then
			TotemTimers[totemN]:SetCooldown(0, 0);
		else
			TotemTimers[totemN]:SetCooldown(startTime, duration)
		end
	end
end
end
