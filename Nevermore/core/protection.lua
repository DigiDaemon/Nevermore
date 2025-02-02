------------------------------------------------------------------------
-- We don't want 2 addons enabled doing the same thing. 
-- Disable a feature on Nevermore if X addon is found.
------------------------------------------------------------------------

local T, C, L = unpack(select(2, ...))

if (IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") or IsAddOnLoaded("ag_UnitFrames")) then
	C["unitframes"].enable = false
end

if (IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft")) then
	C["nameplate"].enable = false
end

if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	C["actionbar"].enable = false
end

if (IsAddOnLoaded("Prat") or IsAddOnLoaded("Chatter")) then
	C["chat"].enable = false
end

if (IsAddOnLoaded("Quartz") or IsAddOnLoaded("AzCastBar") or IsAddOnLoaded("eCastingBar")) then
	C["unitframes"].unitcastbar = false
end

if (IsAddOnLoaded("TipTac")) then
	C["tooltip"].enable = false
end

if (IsAddOnLoaded("Gladius")) then
	C["arena"].unitframes = false
end

if (IsAddOnLoaded("SatrinaBuffFrame") or IsAddOnLoaded("ElkBuffBars")) then
	C["auras"].player = false
end
