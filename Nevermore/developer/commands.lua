-- a command to show frame you currently have mouseovered
SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
 
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end

-- enable lua error by command
function SlashCmdList.LUAERROR(msg, editbox)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		-- because sometime we need to /rl to show an error on login.
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
	else
		print("/luaerror on - /luaerror off")
	end
end
SLASH_LUAERROR1 = '/luaerror'

local testui = TestUI or function() end
TestUI = function(msg)
    if msg == "a" or msg == "arena" then
        NevermoreArena1:Show(); NevermoreArena1.Hide = function() end; NevermoreArena1.unit = "player"
        NevermoreArena2:Show(); NevermoreArena2.Hide = function() end; NevermoreArena2.unit = "player"
        NevermoreArena3:Show(); NevermoreArena3.Hide = function() end; NevermoreArena3.unit = "player"
    elseif msg == "boss" or msg == "b" then
        NevermoreBoss1:Show(); NevermoreBoss1.Hide = function() end; NevermoreBoss1.unit = "player"
        NevermoreBoss2:Show(); NevermoreBoss2.Hide = function() end; NevermoreBoss2.unit = "player"
        NevermoreBoss3:Show(); NevermoreBoss3.Hide = function() end; NevermoreBoss3.unit = "player"
    elseif msg == "pet" then
		NevermorePet:Show(); NevermorePet.Hide = function() end; NevermorePet.unit = "player"
	elseif msg == "buffs" then
        UnitAura = function()
            -- name, rank, texture, count, dtype, duration, timeLeft, caster
            return 139, 'Rank 1', 'Interface\\Icons\\Spell_Holy_Penance', 1, 'Magic', 0, 0, "player"
        end
		
        if(oUF) then
            for i, v in pairs(oUF.units) do
                if(v.UNIT_AURA) then
                    v:UNIT_AURA("UNIT_AURA", v.unit)
                end
            end
        end
    end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"
