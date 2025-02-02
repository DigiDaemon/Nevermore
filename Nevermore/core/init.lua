----------------------------------------------------------------
-- Initiation of Nevermore engine
----------------------------------------------------------------

-- including system
local addon, engine = ...
engine[1] = {} -- T, functions, constants, variables
engine[2] = {} -- C, config
engine[3] = {} -- L, localization

Nevermore = engine -- Allow other addons to use Engine

--[[
		This should be at the top of every file inside of the Nevermore AddOn:	
		local T, C, L = unpack(select(2, ...))

		This is how another addon imports the Nevermore engine:	
		local T, C, L = unpack(Nevermore)
--]]

--------------------------------------------------
-- We need this as soon we begin loading Nevermore
--------------------------------------------------

local T, C, L = unpack(select(2, ...))

T.dummy = function() return end
T.myname = select(1, UnitName("player"))
T.myclass = select(2, UnitClass("player"))
T.myrace = select(2, UnitRace("player"))
T.myfaction = UnitFactionGroup("player")
T.client = GetLocale() 
T.resolution = GetCVar("gxResolution")
T.screenheight = tonumber(string.match(T.resolution, "%d+x(%d+)"))
T.screenwidth = tonumber(string.match(T.resolution, "(%d+)x+%d"))
T.version = GetAddOnMetadata("Nevermore", "Version")
T.versionnumber = tonumber(T.version)
T.incombat = UnitAffectingCombat("player")
T.patch, T.buildtext, T.releasedate, T.toc = GetBuildInfo()
T.build = tonumber(T.buildtext)
T.level = UnitLevel("player")
T.myrealm = GetRealmName()
T.InfoLeftRightWidth = 370
