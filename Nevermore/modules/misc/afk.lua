local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
---------------------------------------------------------------------------
-- setup AFK Notice
---------------------------------------------------------------------------

local AFK, hour, minute
local total = 0
local afk_minutes = 0
local afk_seconds = 0
local update = 0
local interval = 1.0

local frame = CreateFrame("Frame", "frame", UIParent)
	frame:CreatePanel("Default", 1, 1, "CENTER", UIParent, "CENTER", 0, 1)
	frame:SetWidth(NevermoreChat:GetWidth() /1.5)
	frame:SetHeight(NevermoreChat:GetHeight() /1.5)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(1)
	frame:Hide()

local font = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	font:SetText("You are AFK!")
	font:SetPoint("TOP", frame, "TOP", 0, -20)
local timer = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	timer:SetText("0:00")
	timer:SetPoint("TOP", frame, "TOP", 0, -55)

function button_OnClick()
	frame:Hide();
	if UnitIsAFK("player") then
        	SendChatMessage("", "AFK");
        	timer:SetText("0:00")
	end
end

local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	T.SkinButton(button)
	button:SetHeight(25)
	button:SetWidth(55)
	button:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)
	button:SetText("I'm Back!")
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", button_OnClick)

function frame_OnLoad(self)
	self:SetScript("OnEvent", frame_OnEvent)
	self:RegisterEvent("PLAYER_FLAGS_CHANGED");
end

function frame_OnEvent(self, event, ...)
	if (event == "PLAYER_FLAGS_CHANGED") then
		if UnitIsAFK("player") then
			frame:Show();
            AFK = true
            hour, minute = GetGameTime()
            frame:SetScript("OnUpdate", frame_OnUpdate)
        else
            AFK = false
            total = 0
		if UnitIsAFK("player") == nil then
			frame:Hide();
		
            frame:SetScript("OnUpdate", nil)
		end
		end
	end
end

function frame_OnUpdate(self, elapsed)
	if AFK == true then
		update = update + elapsed
		if update > interval then
			total = total + 1
			frame_ParseSeconds(total)
			update = 0
		end
	end
end

function frame_ParseSeconds(num)
	local minutes = afk_minutes
	local seconds = afk_seconds
	if num >= 60 then
		minutes = floor(num / 60)
		seconds = tostring(num - (minutes * 60))
		frame_DisplayTime(minutes, seconds)
	else
		minutes = 0
		seconds = num
        frame_DisplayTime(minutes, seconds)
	end
	afk_minutes = tostring(minutes)
	afk_seconds = tostring(seconds)
end

function frame_DisplayTime(minutes, seconds)
	timer:SetText(tostring(minutes)..":"..string.format("%02d", tostring(seconds)))
end

frame_OnLoad(frame);
