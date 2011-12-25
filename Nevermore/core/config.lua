----------------------------------------------------------------------------
-- This Module loads new user settings if Nevermore_ConfigUI is loaded
----------------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

local myPlayerRealm = GetCVar("realmName")
local myPlayerName  = UnitName("player")

if not IsAddOnLoaded("Nevermore_ConfigUI") then return end

if not NevermoreConfigAll then NevermoreConfigAll = {} end		
if (NevermoreConfigAll[myPlayerRealm] == nil) then NevermoreConfigAll[myPlayerRealm] = {} end
if (NevermoreConfigAll[myPlayerRealm][myPlayerName] == nil) then NevermoreConfigAll[myPlayerRealm][myPlayerName] = false end

if NevermoreConfigAll[myPlayerRealm][myPlayerName] == true and not NevermoreConfigPrivate then return end
if NevermoreConfigAll[myPlayerRealm][myPlayerName] == false and not NevermoreConfigPublic then return end

local setting
if NevermoreConfigAll[myPlayerRealm][myPlayerName] == true then
	setting = NevermoreConfigPrivate
else
	setting = NevermoreConfigPublic
end

for group,options in pairs(setting) do
	if C[group] then
		local count = 0
		for option,value in pairs(options) do
			if C[group][option] ~= nil then
				if C[group][option] == value then
					setting[group][option] = nil	
				else
					count = count+1
					C[group][option] = value
				end
			end
		end
		-- keeps NevermoreConfig clean and small
		if count == 0 then setting[group] = nil end
	else
		setting[group] = nil
	end
end
