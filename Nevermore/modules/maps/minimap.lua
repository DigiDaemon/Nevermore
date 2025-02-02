local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- Nevermore Minimap Script
--------------------------------------------------------------------

local NevermoreMinimap = CreateFrame("Frame", "NevermoreMinimap", UIParent)
NevermoreMinimap:CreatePanel("Default", 1, 1, "CENTER", UIParent, "CENTER", 0, 0)
NevermoreMinimap:RegisterEvent("ADDON_LOADED")
NevermoreMinimap:Point("TOPRIGHT", UIParent, "TOPRIGHT", -T.buttonspacing, -T.buttonsize)
NevermoreMinimap:Size(144)
NevermoreMinimap:SetClampedToScreen(true)
NevermoreMinimap:SetMovable(true)
NevermoreMinimap.text = T.SetFontString(NevermoreMinimap, C.media.uffont, 12)
NevermoreMinimap.text:SetPoint("CENTER")
NevermoreMinimap.text:SetText(L.move_minimap)

-- kill the minimap cluster
MinimapCluster:Kill()

-- Parent Minimap into our Map frame.
Minimap:SetParent(NevermoreMinimap)
Minimap:ClearAllPoints()
Minimap:Point("TOPLEFT", 2, -2)
Minimap:Point("BOTTOMRIGHT", -2, 2)

-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Tracking Button
MiniMapTracking:Hide()

-- Hide Calendar Button
GameTimeFrame:Hide()

-- Hide Mail Button
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:Point("TOPRIGHT", Minimap, 3, 3)
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Nevermore\\medias\\textures\\mail")

-- Move battleground icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("BOTTOMRIGHT", Minimap, 3, 0)
MiniMapBattlefieldBorder:Hide()

-- Ticket Frame
local NevermoreTicket = CreateFrame("Frame", "NevermoreTicket", NevermoreMinimap)
NevermoreTicket:CreatePanel("Default", 1, 1, "CENTER", NevermoreMinimap, "CENTER", 0, 0)
NevermoreTicket:Size(NevermoreMinimap:GetWidth() - 4, 24)
NevermoreTicket:SetFrameStrata("MEDIUM")
NevermoreTicket:SetFrameLevel(20)
NevermoreTicket:Point("TOP", 0, -2)
NevermoreTicket:FontString("Text", C.media.font, 12)
NevermoreTicket.Text:SetPoint("CENTER")
NevermoreTicket.Text:SetText(HELP_TICKET_EDIT)
NevermoreTicket:SetBackdropBorderColor(255/255, 243/255,  82/255)
NevermoreTicket.Text:SetTextColor(255/255, 243/255,  82/255)
NevermoreTicket:SetAlpha(0)

HelpOpenTicketButton:SetParent(NevermoreTicket)
HelpOpenTicketButton:SetFrameLevel(NevermoreTicket:GetFrameLevel() + 1)
HelpOpenTicketButton:SetFrameStrata(NevermoreTicket:GetFrameStrata())
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetAllPoints()
HelpOpenTicketButton:SetHighlightTexture(nil)
HelpOpenTicketButton:SetAlpha(0)
HelpOpenTicketButton:HookScript("OnShow", function(self) NevermoreTicket:SetAlpha(1) end)
HelpOpenTicketButton:HookScript("OnHide", function(self) NevermoreTicket:SetAlpha(0) end)

-- Hide world map button
MiniMapWorldMapButton:Hide()

-- shitty 3.3 flag to move
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- 4.0.6 Guild instance difficulty
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- Reposition lfg icon at bottom-left
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, 1)
	MiniMapLFGFrameBorder:Hide()
end
if T.toc < 40300 then
	hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)
else
	hooksecurefunc("MiniMapLFG_Update", UpdateLFG)
end

-- reskin LFG dropdown
local status
if T.toc >= 40300 then status = LFGSearchStatus else status = LFDSearchStatus end
status:SetTemplate("Default")

-- for t13+, if we move map we need to point status according to our Minimap position.
local function UpdateLFGTooltip()
	local position = NevermoreMinimap:GetPoint()
	status:ClearAllPoints()
	if position:match("BOTTOMRIGHT") then
		status:SetPoint("BOTTOMRIGHT", MiniMapLFGFrame, "BOTTOMLEFT", 0, 0)
	elseif position:match("BOTTOM") then
		status:SetPoint("BOTTOMLEFT", MiniMapLFGFrame, "BOTTOMRIGHT", 4, 0)
	elseif position:match("LEFT") then		
		status:SetPoint("TOPLEFT", MiniMapLFGFrame, "TOPRIGHT", 4, 0)
	else
		status:SetPoint("TOPRIGHT", MiniMapLFGFrame, "TOPLEFT", 0, 0)	
	end
end
status:HookScript("OnShow", UpdateLFGTooltip)

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

-- Set Square Map Mask
Minimap:SetMaskTexture(C.media.blank)

-- For others mods with a minimap button, set minimap buttons position in square mode.
function GetMinimapShape() return "SQUARE" end

-- do some stuff on addon loaded or player login event
NevermoreMinimap:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TimeManager" then
		-- Hide Game Time
		TimeManagerClockButton:Kill()
	end
end)

----------------------------------------------------------------------------------------
-- Map menus, right/middle click
----------------------------------------------------------------------------------------

Minimap:SetScript("OnMouseUp", function(self, btn)
	local xoff = 0
	local position = NevermoreMinimap:GetPoint()
	
	if btn == "RightButton" then	
		if position:match("RIGHT") then xoff = T.Scale(-8) end
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, NevermoreMinimap, xoff, T.Scale(-2))
	elseif btn == "MiddleButton" then
		if not NevermoreMicroButtonsDropDown then return end
		if position:match("RIGHT") then xoff = T.Scale(-160) end
		EasyMenu(T.MicroMenu, NevermoreMicroButtonsDropDown, "cursor", xoff, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)

----------------------------------------------------------------------------------------
-- Mouseover map, displaying zone and coords
----------------------------------------------------------------------------------------

local m_zone = CreateFrame("Frame","NevermoreMinimapZone",NevermoreMinimap)
m_zone:CreatePanel("", 0, 20, "TOP", PP5, "TOP", 2,-2)
m_zone:SetFrameLevel(5)
m_zone:SetFrameStrata("LOW")
m_zone:SetWidth(150)
m_zone:Point("TOP", PP5,-2,-2)
m_zone:SetBackdropColor(0, 0, 0, 0)
m_zone:SetBackdropBorderColor(0, 0, 0, 0)
m_zone:SetAlpha(1)

local m_zone_text = m_zone:CreateFontString("NevermoreMinimapZoneText","Overlay")
m_zone_text:SetFont(C["media"].font,12)
m_zone_text:Point("TOP", 0, -1)
m_zone_text:SetPoint("BOTTOM")
m_zone_text:Height(12)
m_zone_text:Width(m_zone:GetWidth()-6)
m_zone_text:SetAlpha(1)

local m_cover = CreateFrame("Frame","NevermoreMinimapCoordCover",NevermoreMinimap)
m_cover:CreatePanel("", 36, 5, "TOP", m_zone, "BOTTOM", 0, 2)
m_cover:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8", 
            edgeFile = "Interface\\Buttons\\WHITE8x8", 
            tile = false,
            tileSize = 0,
            edgeSize = 1, 
            insets = {
            left = -1,
            right = -1,
            top = -1,
            bottom = -1
            }
        });
m_cover:SetBackdropColor(0, 0, 0, 1);
m_cover:SetBackdropBorderColor(0, 0, 0);
m_cover:SetFrameStrata("MEDIUM")
m_cover:SetAlpha(1)

local m_coord = CreateFrame("Frame","NevermoreMinimapCoord",NevermoreMinimap)
m_coord:CreatePanel("", 40, 20, "TOP", m_zone, "BOTTOM", 0, 0)
m_coord:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8", 
            edgeFile = "Interface\\Buttons\\WHITE8x8", 
            tile = false,
            tileSize = 0,
            edgeSize = 1, 
            insets = {
            left = 0,
            right = 0,
            top = -1,
            bottom = -1
            }
        });
m_coord:SetBackdropColor(0, 0, 0, 1);
m_coord:SetBackdropBorderColor(0.6, 0.6, 0.6);
m_coord:SetFrameStrata("LOW")
m_coord:SetAlpha(1)

local m_coord_text = m_coord:CreateFontString("NevermoreMinimapCoordText","Overlay")
m_coord_text:SetFont(C["media"].font,12)
m_coord_text:Point("Center",-1,0)
m_coord_text:SetAlpha(1)
m_coord_text:SetText("00,00")
 
local ela = 0
local coord_Update = function(self,t)
	ela = ela - t
	if ela > 0 then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		m_coord_text:SetText("X _ X")
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		m_coord_text:SetText(xt..","..yt)
	end
	ela = .2
end
m_coord:SetScript("OnUpdate",coord_Update)
 
local zone_Update = function()
	local pvp = GetZonePVPInfo()
	m_zone_text:SetText(GetMinimapZoneText())
	if pvp == "friendly" then
		m_zone_text:SetTextColor(0.1, 1.0, 0.1)
	elseif pvp == "sanctuary" then
		m_zone_text:SetTextColor(0.41, 0.8, 0.94)
	elseif pvp == "arena" or pvp == "hostile" then
		m_zone_text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvp == "contested" then
		m_zone_text:SetTextColor(1.0, 0.7, 0.0)
	else
		m_zone_text:SetTextColor(1.0, 1.0, 1.0)
	end
end
 
m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent",zone_Update)
