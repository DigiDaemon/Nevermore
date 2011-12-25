local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local role
local tree = GetPrimaryTalentTree()

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Nevermore" then
		for k,v in pairs(NevermoreDataPerChar) do
  			if k == "role" and v == "dps" then
--GroupAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
			end
  			if k == "role" and v == "heal" then		
--GroupAnchor:SetPoint("BOTTOM", NevermoreCenter, "TOP", T.buttonspacing, -T.buttonspacing)
			end
			if k == "role" and v == "tank" then
--GroupAnchor:SetPoint("TOPLEFT", NevermoreInfo, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
 			end
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent);

--[[
	local myAddon = CreateFrame( "Frame", "MyAddonFrame", UIParent );
	local updateFrequency = 30.0; -- maximum number of times I want to update per second (helps reduce load)

	-- create functions to build the layouts... these will only be called
	-- when the addon and its saved variables are first loaded

	local function CreateDPSLayout()
		-- do stuff required to build the DPS layout
	end

	local function CreateTankLayout()
		-- do stuff required to build the tank layout
	end

	local function CreateHealerLayout()
		-- do stuff required to build the healer layout
	end

	-- create functions to update the layouts... these will likely be
	-- called about 30 times a second give or take depending on the
	-- player's computer and what other mods they are running

	local function UpdateDPSLayout( elapsedTime )
		-- do stuff required to update the DPS layout
	end

	local function UpdateTankLayout( elapsedTime )
		-- do stuff required to update the tank layout
	end

	local function UpdateHealerLayout( elapsedTime )
		-- do stuff required to update the healer layout
	end
	
	-- create an event dispatcher for my addon

	local function EventHandler( who, event, ... )

		local arg1 = ...;

		if event == "ADDON_LOADED" and arg1 == "myAddon" then
			if mySavedVars.role == "DPS" then CreateDPSLayout();
			elseif mySavedVars.role == "TANK" then CreateTankLayout();
			else CreateHealerLayout();
			end
		end
	end

	-- create an update manager for my addon

	local timeToNextUpdate = 0.0;

	local function UpdateManager( who, elapsedTime )

		timeToNextUpdate = timeToNextUpdate - elapsedTime;

		if timeToNextUpdate <= 0.0 then

			timeToNextUpdate = 1.0 / updateFreqency;

			if mySavedVars.role == "DPS" then UpdateDPSLayout( elapsedTime );
			elseif mySavedVars.role == "TANK" then UpdateTankLayout( elapsedTime );
			else UpdateHealerLayout( elapsedTime );
			end
		end
	end

	myAddon:SetScript( "OnUpdate", UpdateManager );
	myAddon:SetScript( "OnEvent", EventHandler );
	myAddon:RegisterEvent( "ADDON_LOADED" );
]]--

--[[local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Nevermore" then
		for k,v in pairs(NevermoreDataPerChar) do print(k,v) end
  	if NevermoreDataPerChar.role == "dps" then
   		print("local dps yes");
	else
  		 print("local dps no");
  	end
  	if NevermoreDataPerChar.role == "heal" then
   		print("local heal yes");
	else
   		print("local heal no");
  	end
  	if NevermoreDataPerChar.role == "tank" then
   		print("local tank yes");
	else
   		print("local tank no");
 	end
	end
end
frame:SetScript("OnEvent", frame.OnEvent);]]--
