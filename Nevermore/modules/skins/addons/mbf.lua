local T, C, L = unpack(select(2, ...))
local _, ns = ...

-- ***** Minimap Button Frames ***** --
if (IsAddOnLoaded("MinimapButtonFrame")) then
	MBF.db.profile = default
	MBF.db.profile.locked = true
	MBF.db.profile.sort_by_rows = true
	MBF.db.profile.columns_or_rows = 1
	MBF.db.profile.MBFBackdropColor = { Red = 0, Green = 0, Blue = 0, Alpha = 0 }
	MBF.db.profile.addonScale = .1
	MBF.db.profile.ButtonOverride = { "notesiconframe", "duckiebank_minimapicon", "cta_minimapicon", "BejeweledMinimapIcon", "EMPMINIMAPBUTTON", "MobMapMinimapButtonFrame", "Karma_MinimapIconFrame", "FuBarPluginCraftNotesFrameMinimapButton", "PeggledMinimapIcon", "DropCount_MinimapIcon", "Equi_NotepadButton" }
	MBF.db.profile.padding = 0
	MBF.db.profile.MBF_FrameLocation = { "BOTTOMLEFT", "BOTTOMLEFT", HelpMicroButton:GetWidth() * 11, (NevermoreChat:GetHeight() * 1.5) + (NevermoreMicroMenu:GetHeight() * 1.5)}
	MBF.db.profile.currentTexture = "Blizzard Square"

local MMButtons = CreateFrame("Frame", "MMButtons", UIParent)
	MMButtons:CreatePanel("", MinimapButtonFrame:GetWidth(), 22, "TOPRIGHT", NevermoreMinimap, "TOPLEFT", -NevermoreMinimap:GetWidth(), 5)
	MMButtons:SetBackdropColor(0.1, 0.1, 0.1, 0)
	MMButtons:SetBackdropBorderColor(0.5, 0.5, 0.5, 0)

MinimapButtonFrameDragButton:Hide()
MBFRestoreButtonFrame:Hide()
MinimapButtonFrame:ClearAllPoints()
MinimapButtonFrame:SetScale(.6)
MinimapButtonFrame:SetParent(MMButtons)
MinimapButtonFrame:SetPoint("TOPRIGHT", MMButtons, "TOPRIGHT", 0, -15);
MinimapButtonFrame:SetBackdropColor(0,0,0,0);
MinimapButtonFrame:SetBackdropBorderColor(0,0,0,0);
else 
	return
end
