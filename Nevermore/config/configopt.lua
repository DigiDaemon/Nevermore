local T, C, L = unpack(select(2, ...))

local NevermoreOnLogon = CreateFrame("Frame")
NevermoreOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
NevermoreOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- create empty saved vars if they doesn't exist.
	if (NevermoreData == nil) then NevermoreData = {} end
	if (NevermoreDataPerChar == nil) then NevermoreDataPerChar = {} end
	if (NevermoreConfig == nil) then NevermoreConfig = {} end
		NevermoreConfig.global = {}
		NevermoreConfig.global.install = true
end)



-- ***** Main Name ***** --
Nevermore = {};
Nevermore.panel = CreateFrame( "Frame", "Nevermore", UIParent );
Nevermore.panel.name = "Nevermore";
InterfaceOptions_AddCategory(Nevermore.panel);

Nevermore.unitframes = CreateFrame( "Frame", "NevermoreChild", Nevermore.panel);
Nevermore.unitframes.name = (L.unitframes);
Nevermore.unitframes.parent = Nevermore.panel.name;
InterfaceOptions_AddCategory(Nevermore.unitframes);


