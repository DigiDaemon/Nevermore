local T, C, L = unpack(select(2, ...))

if not C["actionbar"].enable == true then
	NevermorePetBar:Hide()
	NevermoreBar5:Hide()
	NevermoreBar6:Hide()
	NevermoreBar7:Hide()
	NevermoreBar5ButtonTop:Hide()
	NevermoreBar5ButtonBottom:Hide()
	return
end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local NevermoreOnLogon = CreateFrame("Frame")
NevermoreOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
NevermoreOnLogon:SetScript("OnEvent", function(self, event)	
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- look if our 4 bars are enabled because some people disable them with others UI 
	-- even if Nevermore have been already installed and they don't know how to restore them.
	local installed = NevermoreDataPerChar.install
	if installed then
		local b1, b2, b3, b4 = GetActionBarToggles()
		if (not b1 or not b2 or not b3 or not b4) then
			SetActionBarToggles(1, 1, 1, 1)
			StaticPopup_Show("Nevermore_FIX_AB")
		end
	end
	
	-- enable or disable grid display
	if C["actionbar"].showgrid == true then
		ActionButton_HideGrid = T.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)
