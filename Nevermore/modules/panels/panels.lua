local T, C, L = unpack(select(2, ...))

-- ***** Nevermore Center Panel ***** --
local NevermoreCenter = CreateFrame("Frame", "NevermoreCenter", UIParent)
	NevermoreCenter:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 1)
	NevermoreCenter:SetWidth((T.buttonsize * 20) + (T.buttonspacing * 27))
	NevermoreCenter:SetHeight(175)
	NevermoreCenter:SetFrameStrata("BACKGROUND")
	NevermoreCenter:SetFrameLevel(1)

-- ***** Nevermore Chat Panel ***** --
local NevermoreChat = CreateFrame("Frame", "NevermoreChat", UIParent)
	NevermoreChat:CreatePanel("Default", 1, 1, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
	NevermoreChat:SetWidth(T.InfoLeftRightWidth)
	NevermoreChat:SetHeight(175)
	NevermoreChat:SetFrameStrata("BACKGROUND")
	NevermoreChat:SetFrameLevel(1)

local NevermoreChatEdit = CreateFrame("Frame", "NevermoreChatEdit", UIParent)
	NevermoreChatEdit:CreatePanel("Default", 1, 1, "TOPLEFT", "NevermoreChat", "TOPLEFT", -1, 1)
	NevermoreChatEdit:Point("TOPLEFT", "NevermoreChat", "TOPLEFT", T.buttonspacing, -T.buttonspacing)
	NevermoreChatEdit:Point("TOPRIGHT", "NevermoreChat", "TOPRIGHT", -(T.buttonsize + T.buttonspacing *1.5), -T.buttonspacing)
	NevermoreChatEdit:SetHeight(24)
	NevermoreChatEdit:SetFrameStrata("BACKGROUND")
	NevermoreChatEdit:SetFrameLevel(1)

-- ***** Nevermore Info Panel ***** --
local NevermoreInfo = CreateFrame("Frame", "NevermoreInfo", UIParent)
	NevermoreInfo:CreatePanel("Default", 1, 1, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -1, 1)
	NevermoreInfo:SetWidth(T.InfoLeftRightWidth)
	NevermoreInfo:SetHeight(175)
	NevermoreInfo:SetFrameStrata("BACKGROUND")
	NevermoreInfo:SetFrameLevel(1)

-- ***** Nevermore Micro Menu Frame ***** --
local NevermoreMicroMenu = CreateFrame("Frame", "NevermoreMicroMenu", UIParent)
	NevermoreMicroMenu:CreatePanel(nil, NevermoreChat:GetWidth(), NevermoreChat:GetHeight()/7.9, "BOTTOMLEFT", NevermoreChat, "TOPLEFT", 0, T.buttonspacing )

-- ***** Nevermore Info Bar ***** --
local NevermoreInfoBar = CreateFrame("Frame", "NevermoreInfoBar", UIParent)
	NevermoreInfoBar:CreatePanel("Default", 1, 1, "TOP", UIParent, "TOP", 0, -1)
	NevermoreInfoBar:Point("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
	NevermoreInfoBar:Point("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
	NevermoreInfoBar:SetWidth(T.InfoLeftRightWidth + (T.buttonspacing * 2))
	NevermoreInfoBar:SetHeight(23)
	NevermoreInfoBar:SetFrameStrata("BACKGROUND")
	NevermoreInfoBar:SetFrameLevel(1)

-- ***** Nevermore Stance Bar Panel ***** --
local NevermoreStance = CreateFrame("Frame", "NevermoreStance", UIParent)
if T.myclass == "SHAMAN" then
	NevermoreStance:CreatePanel("Default", 1, 1, "BOTTOMRIGHT", NevermoreChat, "TOPRIGHT", 0, T.buttonsize + T.buttonspacing)
	NevermoreStance:SetWidth(NevermoreChat:GetWidth() /3)
	NevermoreStance:SetHeight(T.buttonsize)
	NevermoreStance:SetFrameStrata("LOW")
	NevermoreStance:SetFrameLevel(1)
else

	NevermoreStance:CreatePanel("Default", 1, 1, "BOTTOMLEFT", NevermoreChat, "BOTTOMRIGHT", T.buttonspacing, 0)
	NevermoreStance:SetWidth(T.buttonsize + T.buttonspacing - 2)
	NevermoreStance:SetHeight(NevermoreChat:GetHeight() + NevermoreMicroMenu:GetHeight() + T.buttonspacing)
	NevermoreStance:SetFrameStrata("LOW")
	NevermoreStance:SetFrameLevel(1)
end

-- ***** Nevermore Profession Panel ***** --
local NevermoreProfession = CreateFrame("Frame", "NevermoreProfession", UIParent)
	NevermoreProfession:CreatePanel("Default", 1, 1, "BOTTOMRIGHT", NevermoreInfo, "BOTTOMLEFT", -T.buttonspacing, 0)
	NevermoreProfession:SetWidth(T.buttonsize + T.buttonspacing - 2)
	NevermoreProfession:SetHeight(NevermoreChat:GetHeight() + NevermoreMicroMenu:GetHeight() + T.buttonspacing)
	NevermoreProfession:SetFrameStrata("BACKGROUND")
	NevermoreProfession:SetFrameLevel(1)

-- ***** Nevermore Bar 1 Panel ***** --
local NevermoreBar1 = CreateFrame("Frame", "NevermoreBar1", UIParent, "SecureHandlerStateTemplate")
	NevermoreBar1:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 14)
	NevermoreBar1:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	NevermoreBar1:SetHeight((T.buttonsize * 1) + (T.buttonspacing * 2))
	NevermoreBar1:SetFrameStrata("BACKGROUND")
	NevermoreBar1:SetFrameLevel(1)

-- ***** Nevermore Bar 2 Panel ***** --
local NevermoreBar2 = CreateFrame("Frame", "NevermoreBar2", NevermoreBar1)
	NevermoreBar2:CreatePanel("Default", 1, 1, "BOTTOM", NevermoreBar1, "BOTTOM", 0, 0)
	NevermoreBar2:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	NevermoreBar2:SetHeight((T.buttonsize * 2) + (T.buttonspacing * 3))
	NevermoreBar2:SetFrameStrata("BACKGROUND")
	NevermoreBar2:SetFrameLevel(2)

-- ***** Nevermore Bar 3 Panel ***** --
local NevermoreBar3 = CreateFrame("Frame", "NevermoreBar3", NevermoreBar2)
	NevermoreBar3:CreatePanel("Default", 1, 1, "BOTTOM", NevermoreBar2, "BOTTOM", 0, 0)
	NevermoreBar3:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	NevermoreBar3:SetHeight((T.buttonsize * 3) + (T.buttonspacing * 4))
	NevermoreBar3:SetFrameStrata("BACKGROUND")
	NevermoreBar3:SetFrameLevel(3)

-- ***** Nevermore Bar 4 Panel ***** --
local NevermoreBar4 = CreateFrame("Frame", "NevermoreBar4", NevermoreBar1)
	NevermoreBar4:CreatePanel("Default", 1, 1, "BOTTOMRIGHT", NevermoreBar1, "BOTTOMLEFT", -T.buttonspacing, 0)
	NevermoreBar4:SetWidth((T.buttonsize * 4) + (T.buttonspacing * 5))
	NevermoreBar4:SetHeight((T.buttonsize * 3) + (T.buttonspacing * 4))
	NevermoreBar4:SetFrameStrata("BACKGROUND")
	NevermoreBar4:SetFrameLevel(3)

-- ***** Nevermore Bar 5 Panel ***** --
local NevermoreBar5 = CreateFrame("Frame", "NevermoreBar5", NevermoreBar1)
	NevermoreBar5:CreatePanel("Default", 1, 1, "BOTTOMLEFT", NevermoreBar1, "BOTTOMRIGHT", T.buttonspacing, 0)
	NevermoreBar5:SetWidth((T.buttonsize * 4) + (T.buttonspacing * 5))
	NevermoreBar5:SetHeight((T.buttonsize * 3) + (T.buttonspacing * 4))
	NevermoreBar5:SetFrameStrata("BACKGROUND")
	NevermoreBar5:SetFrameLevel(3)

-- ***** Nevermore Pet Background Panel ***** --
local petbg = CreateFrame("Frame", "NevermorePetBar", UIParent, "SecureHandlerStateTemplate")
petbg:CreatePanel("Default", T.petbuttonsize + (T.petbuttonspacing * 2), (T.petbuttonsize * 10) + (T.petbuttonspacing * 11), "RIGHT", UIParent, "RIGHT", 0, -14)
petbg:SetAlpha(1)

if not C.chat.background then
	-- CUBE AT LEFT, ACT AS A BUTTON (CHAT MENU)
	local cubeleft = CreateFrame("Frame", "NevermoreCubeLeft", NevermoreBar1)
	cubeleft:CreatePanel("Default", T.buttonsize, 24, "TOPRIGHT", NevermoreChat, "TOPRIGHT", -T.buttonspacing, -T.buttonspacing)
	cubeleft.text = T.SetFontString(cubeleft, C.media.uffont, 14)
	cubeleft.text:Point("CENTER", 1, 1)
	cubeleft.text:SetText("|cffFFFFFFO|r")
	cubeleft:EnableMouse(true)
	cubeleft:SetScript("OnMouseDown", function(self, btn)
		if NevermoreInfoLeftBattleGround and UnitInBattleground("player") then
			if btn == "RightButton" then
				if NevermoreInfoLeftBattleGround:IsShown() then
					NevermoreInfoLeftBattleGround:Hide()
				else
					NevermoreInfoLeftBattleGround:Show()
				end
			end
		end
		
		if btn == "LeftButton" then	
			ToggleFrame(ChatMenu)
		end
	end)

	-- CUBE AT RIGHT, ACT AS A BUTTON (CONFIGUI or BG'S)
	local cuberight = CreateFrame("Frame", "NevermoreCubeRight", NevermoreBar1)
	cuberight:CreatePanel("Default", 10, 10, "BOTTOM", irightlv, "TOP", 0, 0)
	if C["bags"].enable then
		cuberight:EnableMouse(true)
		cuberight:SetScript("OnMouseDown", function(self)
			if T.toc < 40200 then ToggleKeyRing() else ToggleAllBags() end
		end)
	end
end

-- MOVE/HIDE SOME ELEMENTS IF CHAT BACKGROUND IS ENABLED
local movechat = 0
if C.chat.background then movechat = 10 ileftlv:SetAlpha(0) irightlv:SetAlpha(0) end

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "NevermoreInfoLeft", NevermoreBar1)
ileft:CreatePanel("Default", T.InfoLeftRightWidth / 2 - (T.buttonspacing / 2), 23, "BOTTOMLEFT", NevermoreInfo, "TOP", T.buttonspacing / 2, T.buttonspacing)
ileft:SetFrameLevel(2)
ileft:SetFrameStrata("BACKGROUND")

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "NevermoreInfoRight", NevermoreBar1)
iright:CreatePanel("Default", T.InfoLeftRightWidth / 2 - (T.buttonspacing / 2), 23, "BOTTOMRIGHT", NevermoreInfo, "TOP", -T.buttonspacing / 2, T.buttonspacing)
iright:SetFrameLevel(2)
iright:SetFrameStrata("BACKGROUND")

if C.chat.background then
	-- Alpha horizontal lines because all panels is dependent on this frame.
	ltoabl:SetAlpha(0)
	ltoabr:SetAlpha(0)
	
	-- CHAT BG LEFT
	local chatleftbg = CreateFrame("Frame", "NevermoreChatBackgroundLeft", NevermoreInfoLeft)
	chatleftbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 177, "BOTTOM", NevermoreInfoLeft, "BOTTOM", 0, -6)

	-- CHAT BG RIGHT
	local chatrightbg = CreateFrame("Frame", "NevermoreChatBackgroundRight", NevermoreInfoRight)
	chatrightbg:CreatePanel("Transparent", T.InfoLeftRightWidth + 12, 177, "BOTTOM", NevermoreInfoRight, "BOTTOM", 0, -6)
	
	-- LEFT TAB PANEL
	local tabsbgleft = CreateFrame("Frame", "NevermoreTabsLeftBackground", NevermoreBar1)
	tabsbgleft:CreatePanel("Default", T.InfoLeftRightWidth, 23, "TOP", chatleftbg, "TOP", 0, -6)
	tabsbgleft:SetFrameLevel(2)
	tabsbgleft:SetFrameStrata("BACKGROUND")
		
	-- RIGHT TAB PANEL
	local tabsbgright = CreateFrame("Frame", "NevermoreTabsRightBackground", NevermoreBar1)
	tabsbgright:CreatePanel("Default", T.InfoLeftRightWidth, 23, "TOP", chatrightbg, "TOP", 0, -6)
	tabsbgright:SetFrameLevel(2)
	tabsbgright:SetFrameStrata("BACKGROUND")
	
	-- [[ Create new horizontal line for chat background ]] --
	-- HORIZONTAL LINE LEFT
	local ltoabl2 = CreateFrame("Frame", "NevermoreLineToABLeftAlt", NevermoreBar1)
	ltoabl2:CreatePanel("Default", 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	ltoabl2:ClearAllPoints()
	ltoabl2:Point("RIGHT", NevermoreBar1, "LEFT", 0, 16)
	ltoabl2:Point("BOTTOMLEFT", chatleftbg, "BOTTOMRIGHT", 0, 16)

	-- HORIZONTAL LINE RIGHT
	local ltoabr2 = CreateFrame("Frame", "NevermoreLineToABRightAlt", NevermoreBar1)
	ltoabr2:CreatePanel("Default", 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	ltoabr2:ClearAllPoints()
	ltoabr2:Point("LEFT", NevermoreBar1, "RIGHT", 0, 16)
	ltoabr2:Point("BOTTOMRIGHT", chatrightbg, "BOTTOMLEFT", 0, 16)
end

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "NevermoreInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(0)
	bgframe:EnableMouse(true)
end
