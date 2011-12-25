local T, C, L = unpack(select(2, ...))
if not NevermoreInfoRight then return end

--[[local aggroColors = {
	[1] = {12/255, 151/255,  15/255},
	[2] = {166/255, 171/255,  26/255},
	[3] = {163/255,  24/255,  24/255},
}]]

local NevermoreThreatBar = CreateFrame("StatusBar", "NevermoreThreatBar", NevermoreInfoRight)
NevermoreThreatBar:Point("TOPLEFT", 2, -2)
NevermoreThreatBar:Point("BOTTOMRIGHT", -2, 2)

NevermoreThreatBar:SetStatusBarTexture(C.media.normTex)
NevermoreThreatBar:GetStatusBarTexture():SetHorizTile(false)
NevermoreThreatBar:SetBackdrop({bgFile = C.media.blank})
NevermoreThreatBar:SetBackdropColor(0, 0, 0, 0)
NevermoreThreatBar:SetMinMaxValues(0, 100)

NevermoreThreatBar.text = T.SetFontString(NevermoreThreatBar, C.media.font, 12)
NevermoreThreatBar.text:Point("RIGHT", NevermoreThreatBar, "RIGHT", -T.buttonspacing, 0)

NevermoreThreatBar.Title = T.SetFontString(NevermoreThreatBar, C.media.font, 12)
NevermoreThreatBar.Title:SetText(L.unitframes_ouf_threattext)
NevermoreThreatBar.Title:SetPoint("LEFT", NevermoreThreatBar, "LEFT", T.buttonspacing, 0)
	  
NevermoreThreatBar.bg = NevermoreThreatBar:CreateTexture(nil, 'BORDER')
NevermoreThreatBar.bg:SetAllPoints(NevermoreThreatBar)
NevermoreThreatBar.bg:SetTexture(C["general"].backdropcolor)

local function OnEvent(self, event, ...)
	local party = GetNumPartyMembers()
	local raid = GetNumRaidMembers()
	local pet = select(1, HasPetUI())
	if event == "PLAYER_ENTERING_WORLD" then
		self:Hide()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" then
		if party > 0 or raid > 0 or pet == 1 then
			self:Show()
		else
			self:Hide()
		end
	else
		if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
			self:Show()
		else
			self:Hide()
		end
	end
end

local function OnUpdate(self, event, unit)
	if UnitAffectingCombat(self.unit) then
		local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
		local threatval = threatpct or 0
		
		self:SetValue(threatval)
		self.text:SetFormattedText("%3.1f", threatval)
		
		local r, g, b = oUFTukui.ColorGradient(threatval/100, 0,.8,0,.8,.8,0,.8,0,0)
		self:SetStatusBarColor(r, g, b)

		if threatval > 0 then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
		end		
	end
end

NevermoreThreatBar:RegisterEvent("PLAYER_ENTERING_WORLD")
NevermoreThreatBar:RegisterEvent("PLAYER_REGEN_ENABLED")
NevermoreThreatBar:RegisterEvent("PLAYER_REGEN_DISABLED")
NevermoreThreatBar:SetScript("OnEvent", OnEvent)
NevermoreThreatBar:SetScript("OnUpdate", OnUpdate)
NevermoreThreatBar.unit = "player"
NevermoreThreatBar.tar = NevermoreThreatBar.unit.."target"
NevermoreThreatBar.Colors = aggroColors
NevermoreThreatBar:SetAlpha(0)
