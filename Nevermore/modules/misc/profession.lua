local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
local _, ns = ...

local TradeEventFrame = CreateFrame("Frame")
TradeEventFrame:RegisterEvent("PLAYER_LOGIN")
TradeEventFrame:SetScript("OnEvent", function(self,event,...) 


local TradeTabs = CreateFrame("Frame","TradeTabs")

local tradeSpells = { -- Spell order in this table determines the tab order
	28596, -- Alchemy
	29844, -- Blacksmithing
	28029, -- Enchanting
	30350, -- Engineering
	45357, -- Inscription
	28897, -- Jewel Crafting
	32549, -- Leatherworking
	53428, -- Runeforging
	2656,  -- Smelting
	26790, -- Tailoring
	33359, -- Cooking
	27028, -- First Aid
	13262, -- Disenchant
	51005, -- Milling
	31252, -- Prospecting
	89722, -- Archeology
	--818,   -- Basic Campfire
	--80451, -- Survey
	--88868, -- Fishing	
}

function TradeTabs:OnEvent(event,...)
	self:UnregisterEvent(event)
	if not IsLoggedIn() then
		self:RegisterEvent(event)
	elseif InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:Initialize()
	end
end

function TradeTabs:Initialize()
	if self.initialized  then return end
		for i=1,#tradeSpells do
		local n = GetSpellInfo(tradeSpells[i])
		tradeSpells[n] = -1
		tradeSpells[i] = n
	end
	
	local parent = NevermoreProfession
	if SkilletFrame then
		parent = SkilletFrame
		self:UnregisterAllEvents()
	end	

	for i=1,MAX_SPELLS do
		local n = GetSpellInfo(i,"spell")
		if tradeSpells[n] then
			tradeSpells[n] = i
		end		
	end

	local prev
	for i,spell in ipairs(tradeSpells) do
		local spellid = tradeSpells[spell]
		if type(spellid) == "number" and spellid > 0 then
			local tab = self:CreateTab(spell,spellid,parent)
			local point,relPoint,x,y = "TOP","BOTTOM",0, -T.buttonspacing
			if not prev then
				prev,relPoint,x,y = parent,"TOP",0, -T.buttonspacing
				if parent == SkilletFrame then x = 0 end
			end
			tab:SetPoint(point,prev,relPoint,x,y)
			prev = tab
		end
	end

	self.initialized = true
end

local function updateSelection(self)
	if IsCurrentSpell(self.spellID,"spell") then
		self:SetChecked(true)
		self.clickStopper:Show()
	else
		self:SetChecked(false)
		self.clickStopper:Hide()
	end
end

local function createClickStopper(button)
    local f = CreateFrame("Frame",nil,button)
    f:SetAllPoints(button)
    f:EnableMouse(true)
    f:SetScript("OnEnter",onEnter)
    f:SetScript("OnLeave",onLeave)
    button.clickStopper = f
    f.tooltip = button.tooltip
    f:Hide()
end


function TradeTabs:CreateTab(spell,spellID,parent)
    local button = CreateFrame("CheckButton",nil ,parent ,"SecureActionButtonTemplate")
	button:SetAttribute("type","spell")
	button:SetAttribute("spell",spell)
	button.spellID = spellID

	button:SetNormalTexture(nil)
	local Overlay = self:CreateTexture(nil, "OVERLAY")
		Overlay:SetTexture(GetSpellTexture(spellID, "spell"))
		Overlay:SetParent(button)
		Overlay:SetPoint("CENTER", button, "CENTER", 0, 0)
		Overlay:Size(T.buttonsize - T.buttonspacing, T.buttonsize - T.buttonspacing)
		Overlay:SetTexCoord(.07, .93, .07, .93)
		self.Overlay = Overlay
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

	button:SetBackdropBorderColor(1,0,0)

	button:SetTemplate("Default")
	button:SetWidth(T.buttonsize)
	button:SetHeight(T.buttonsize)
	button:SetScript("OnEvent",updateSelection)
	button:RegisterEvent("TRADE_SKILL_SHOW")
	button:RegisterEvent("TRADE_SKILL_CLOSE")
	button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

	button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
	button:SetScript("OnLeave", function(self) self:SetAlpha(1) end)
	button.tooltip = spell
	button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreatePanel("Default", T.buttonsize, T.buttonsize, "CENTER", button, "CENTER", 0, 0)
		button.bg:SetFrameLevel(button:GetFrameLevel())
		button.bg:SetFrameStrata(button:GetFrameStrata())
	createClickStopper(button)
	updateSelection(button)
	return button
end



TradeTabs:RegisterEvent("TRADE_SKILL_SHOW")
TradeTabs:RegisterEvent("PLAYER_ENTERING_WORLD")	
TradeTabs:SetScript("OnEvent",TradeTabs.OnEvent)
TradeTabs:Initialize()

end)
