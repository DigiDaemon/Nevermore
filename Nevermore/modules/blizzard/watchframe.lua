local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local NevermoreWatchFrame = CreateFrame("Frame", "NevermoreWatchFrame", UIParent)
NevermoreWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- to be compatible with blizzard option
local wideFrame = GetCVar("watchFrameWidth")

-- create our moving area
local NevermoreWatchFrameAnchor = CreateFrame("Button", "NevermoreWatchFrameAnchor", UIParent)
NevermoreWatchFrameAnchor:SetFrameStrata("HIGH")
NevermoreWatchFrameAnchor:SetFrameLevel(20)
NevermoreWatchFrameAnchor:SetHeight(20)
NevermoreWatchFrameAnchor:SetClampedToScreen(true)
NevermoreWatchFrameAnchor:SetMovable(true)
NevermoreWatchFrameAnchor:EnableMouse(false)
NevermoreWatchFrameAnchor:SetTemplate("Default")
NevermoreWatchFrameAnchor:SetBackdropBorderColor(0,0,0,0)
NevermoreWatchFrameAnchor:SetBackdropColor(0,0,0,0)
NevermoreWatchFrameAnchor.text = T.SetFontString(NevermoreWatchFrameAnchor, C.media.uffont, 12)
NevermoreWatchFrameAnchor.text:SetPoint("CENTER")
NevermoreWatchFrameAnchor.text:SetText(L.move_watchframe)
NevermoreWatchFrameAnchor.text:Hide()

-- set default position according to how many right bars we have
NevermoreWatchFrameAnchor:Point("TOPRIGHT", UIParent, -T.buttonsize*2, -220)

-- width of the watchframe according to our Blizzard cVar.
if wideFrame == "1" then
	NevermoreWatchFrame:SetWidth(350)
	NevermoreWatchFrameAnchor:SetWidth(350)
else
	NevermoreWatchFrame:SetWidth(250)
	NevermoreWatchFrameAnchor:SetWidth(250)
end

local screenheight = T.screenheight
NevermoreWatchFrame:SetParent(NevermoreWatchFrameAnchor)
NevermoreWatchFrame:SetHeight(screenheight / 2)
NevermoreWatchFrame:ClearAllPoints()
NevermoreWatchFrame:SetPoint("TOP")

local function init()
	NevermoreWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	NevermoreWatchFrame:RegisterEvent("CVAR_UPDATE")
	NevermoreWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
		if cvar == "WATCH_FRAME_WIDTH_TEXT" then
			if not WatchFrame.userCollapsed then
				if value == "1" then
					NevermoreWatchFrame:SetWidth(350)
					NevermoreWatchFrameAnchor:SetWidth(350)
				else
					NevermoreWatchFrame:SetWidth(250)
					NevermoreWatchFrameAnchor:SetWidth(250)
				end
			end
			wideFrame = value
		end
	end)
end

local function setup()	
	WatchFrame:SetParent(NevermoreWatchFrame)
	WatchFrame:SetFrameStrata("LOW")
	WatchFrame:SetFrameLevel(3)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32,-2.5)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = T.dummy

	WatchFrameTitle:SetParent(NevermoreWatchFrame)
	WatchFrameCollapseExpandButton:SetParent(NevermoreWatchFrame)
	WatchFrameCollapseExpandButton:SetSize(16, 16)
	WatchFrameCollapseExpandButton:SetTemplate("Default")
	WatchFrameCollapseExpandButton:SetFrameStrata(WatchFrameHeader:GetFrameStrata())
	WatchFrameCollapseExpandButton:SetFrameLevel(WatchFrameHeader:GetFrameLevel() + 1)
	WatchFrameCollapseExpandButton:SetNormalTexture("")
	WatchFrameCollapseExpandButton:SetPushedTexture("")
	WatchFrameCollapseExpandButton:SetHighlightTexture("")
	T.SkinCloseButton(WatchFrameCollapseExpandButton)
	WatchFrameCollapseExpandButton.t:SetFont(C.media.font, 12, "OUTLINE")
	WatchFrameCollapseExpandButton.t:SetPoint("CENTER", 2, 0) 
	WatchFrameCollapseExpandButton:HookScript("OnClick", function(self) 
		if WatchFrame.collapsed then 
			self.t:SetText("V")
			self.t:SetPoint("CENTER", 2, 0) 
		else 
			self.t:SetText("X")
			self.t:SetPoint("CENTER", 2, 0) 
		end 
	end)
	WatchFrameTitle:Kill()
end

------------------------------------------------------------------------
-- Execute setup after we enter world
------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed > .5 then
		setup()
		f:Hide()
	end
end)
NevermoreWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)
