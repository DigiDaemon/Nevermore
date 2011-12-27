local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

	local myAddon = CreateFrame( "Frame", "MyAddonFrame", UIParent );
	myAddon:SetScript( "OnEvent", EventHandler );
	myAddon:RegisterEvent( "ADDON_LOADED" );
	-- create functions to build the layouts... these will only be called
	-- when the addon and its saved variables are first loaded

	local function CreateDPSLayout()
		print("DPS Layout Returned")
		-- do stuff required to build the DPS layout
	end

	local function CreateTankLayout()
		print("Tank Layout Returned")
		-- do stuff required to build the tank layout
	end

	local function CreateHealerLayout()
		print("Heal Layout Returned")
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

	local function EventHandler( event, arg1 )
		if event == "ADDON_LOADED" and arg1 == "Nevermore" then
			if NevermoreDataPerChar.role == "dps" then
				CreateDPSLayout();
			elseif NevermoreDataPerChar.role == "tank" then 
				CreateTankLayout();
			elseif NevermoreDataPerChar.role == "heal" then 
				CreateHealerLayout();
			end
		end
	end


