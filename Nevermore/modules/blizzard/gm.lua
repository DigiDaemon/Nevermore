local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
------------------------------------------------------------------------
--	GM ticket position
------------------------------------------------------------------------

-- create our moving area
local NevermoreGMFrameAnchor = CreateFrame("Button", "NevermoreGMFrameAnchor", UIParent)
NevermoreGMFrameAnchor:SetFrameStrata("TOOLTIP")
NevermoreGMFrameAnchor:SetFrameLevel(20)
NevermoreGMFrameAnchor:SetHeight(40)
NevermoreGMFrameAnchor:SetWidth(TicketStatusFrameButton:GetWidth())
NevermoreGMFrameAnchor:SetClampedToScreen(true)
NevermoreGMFrameAnchor:SetMovable(true)
NevermoreGMFrameAnchor:SetTemplate("Default")
NevermoreGMFrameAnchor:SetBackdropBorderColor(1,0,0,1)
NevermoreGMFrameAnchor:SetBackdropColor(unpack(C.media.backdropcolor))
NevermoreGMFrameAnchor:Point("TOPLEFT", 4, -4)
NevermoreGMFrameAnchor.text = T.SetFontString(NevermoreGMFrameAnchor, C.media.uffont, 12)
NevermoreGMFrameAnchor.text:SetPoint("CENTER")
NevermoreGMFrameAnchor.text:SetText(L.move_gmframe)
NevermoreGMFrameAnchor.text:SetParent(NevermoreGMFrameAnchor)
NevermoreGMFrameAnchor:Hide()

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOP", NevermoreGMFrameAnchor, "TOP")

------------------------------------------------------------------------
--	GM toggle command
------------------------------------------------------------------------

SLASH_GM1 = "/gm"
SlashCmdList["GM"] = function() ToggleHelpFrame() end
