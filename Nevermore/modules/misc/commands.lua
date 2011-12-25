local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- enable or disable an addon via command
SlashCmdList.DISABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then DisableAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_DISABLE_ADDON1 = "/disable"
SlashCmdList.ENABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then EnableAddOn(addon) LoadAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_ENABLE_ADDON1 = "/enable"

-- switch to heal layout via a command
SLASH_NevermoreHEAL1 = "/heal"
SlashCmdList.NevermoreHEAL = function()
NevermoreDataPerChar.role = "heal"
	ReloadUI()
end

-- switch to dps layout via a command
SLASH_NevermoreDPS1 = "/dps"
SlashCmdList.NevermoreDPS = function()
NevermoreDataPerChar.role = "dps"
	ReloadUI()
end

-- switch to tank layout via a command
SLASH_NevermoreTANK1 = "/tank"
SlashCmdList.NevermoreTANK = function()
NevermoreDataPerChar.role = "tank"
	ReloadUI()
end

-- fix combatlog manually when it broke
SLASH_CLFIX1 = "/clfix"
SlashCmdList.CLFIX = CombatLogClearEntries

-- ready check shortcut
SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = "/rc"

SlashCmdList["GROUPDISBAND"] = function()
	if UnitIsRaidOfficer("player") then
		StaticPopup_Show("NevermoreDISBAND_RAID")
	end
end
SLASH_GROUPDISBAND1 = '/rd'

-- Leave party chat command
SlashCmdList["LEAVEPARTY"] = function()
	LeaveParty()
end
SLASH_LEAVEPARTY1 = '/leaveparty'
