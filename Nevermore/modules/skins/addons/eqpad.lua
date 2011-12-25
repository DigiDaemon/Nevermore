local T, C, L = unpack(select(2, ...))
local _, ns = ...

-- ***** Equilibriam Notepad ***** --
-- ***** Release button to minimap ***** --
if (IsAddOnLoaded("Equi_Notepad")) and (IsAddOnLoaded("MinimapButtonFrame")) then
	Equi_NotepadButton:ClearAllPoints()
	Equi_NotepadButton:SetParent("MinimapButtonFrame")
	Equi_NotepadButton:SetPoint("BOTTOM",150,0)
	Equi_NotepadButton:SetFrameStrata("HIGH")
	Equi_NotepadButton:SetMovable(false)
	Equi_NotepadButton:SetWidth(22)
	Equi_NotepadButton:SetHeight(22)
else
	return 
end
