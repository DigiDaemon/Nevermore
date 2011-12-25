-- Always enable profanity
local p = CreateFrame("Frame")
p:RegisterEvent("CVAR_UPDATE")
p:RegisterEvent("PLAYER_ENTERING_WORLD")
p:SetScript("OnEvent", function(self, event, cvar)
	SetCVar("profanityFilter", 0)
end)

-- kill the option
InterfaceOptionsSocialPanelProfanityFilter:Kill()

print("Profanity Filter is now disabled.") 

local frame = CreateFrame("FRAME", "DisableProfanityFilter")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
local function eventHandler(self, event, ...)
	
	isOnline = BNConnected()
	if(isOnline) then
		BNSetMatureLanguageFilter(false)
	end
	
	SetCVar( "profanityFilter", 0)
end
frame:SetScript("OnEvent", eventHandler)
