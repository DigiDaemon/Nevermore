local T, C, L = unpack(select(2, ...))
if not IsAddOnLoaded('TinyDPS') then return end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)	
	-- define our locals
	local frame = tdpsFrame
	local anchor = tdpsAnchor
	local status = tdpsStatusBar
	local tdps = tdps
	local font = tdpsFont
	local position = tdpsPosition
	
	-- set our default configuration
	if tdps then
		tdps.width = NevermoreMinimap:GetWidth()
		tdps.spacing = 2
		tdps.barHeight = 15
		tdps.barbackdrop = {0, 0, 0, 0}
		tdps.layout = 15
		font.name = C["media"].font
		font.size = 11
		font.outline = "OUTLINE"
	end

-- ***** New Title Button ***** --	
local Title = CreateFrame("Frame", "Title", UIParent)
	Title:CreatePanel("", NevermoreMinimap:GetWidth(), 0, "TOPLEFT", NevermoreInfoBar, "BOTTOMLEFT", 0, -T.buttonspacing)
	Title:SetWidth(NevermoreMinimap:GetWidth())
	Title:SetHeight(NevermoreInfoBar:GetHeight())
	Title:SetTemplate(Default)

-- ***** Static Title Text ***** --
local TitleTitle = Title:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	TitleTitle:SetFont(tdpsFont.name, tdpsFont.size)
	TitleTitle:SetText("TinyDPS - Hidden")
	TitleTitle:SetTextColor(1, 1, .5, 0)
	TitleTitle:SetPoint('CENTER', Title, 'CENTER', 0, 0)

-- ***** Meter Background ***** --
local BG = CreateFrame("Frame", "BG", UIParent)
	BG:CreatePanel("", NevermoreMinimap:GetWidth(), 0, "TOPLEFT", Title, "BOTTOMLEFT", 0, -T.buttonspacing)
	BG:SetWidth(NevermoreMinimap:GetWidth())
	BG:SetHeight(NevermoreMinimap:GetHeight() - (NevermoreInfoBar:GetHeight() + T.buttonspacing))
	BG:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8", 
            edgeFile = "Interface\\Buttons\\WHITE8x8", 
            tile = false,
            tileSize = 0,
            edgeSize = 1, 
            insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
            }
        });
BG:SetBackdropColor(0, 0, 0, 0);
BG:SetBackdropBorderColor(0, 0, 0, 0);

-- ***** Hide Button ***** --
local TitleHide = CreateFrame("Button", "TitleHide", UIParent, "SecureActionButtonTemplate")
	TitleHide:CreatePanel("", NevermoreMinimap:GetWidth(), 0, "TOPLEFT", Title, "TOPLEFT", 0, 0)
	TitleHide:SetScript("OnClick", function() BG:Hide() TitleTitle:SetTextColor(1, 1, .5, 1) end)
	TitleHide:SetWidth(T.buttonsize)
	TitleHide:SetHeight(Title:GetHeight())
	TitleHide:SetTemplate(Default)
	TitleHide:SetBackdropBorderColor(0, 0, 0, 0);
	TitleHide.text = T.SetFontString(TitleHide, C.media.uffont, 24)
	TitleHide.text:Point("CENTER", 0, 0)
	TitleHide.text:SetText("|cffFFFFFF-|r")

-- ***** Show Button ***** --
local TitleShow = CreateFrame("Button", "TitleShow", UIParent, "SecureActionButtonTemplate")
	TitleShow:CreatePanel("", NevermoreMinimap:GetWidth(), 0, "TOPRIGHT", Title, "TOPRIGHT", 0, 0)
	TitleShow:SetScript("OnClick", function() BG:Show() TitleTitle:SetTextColor(1, 1, .5, 0) end)
	TitleShow:SetWidth(T.buttonsize)
	TitleShow:SetHeight(Title:GetHeight())
	TitleShow:SetTemplate(Default)
	TitleShow:SetBackdropBorderColor(0, 0, 0, 0);
	TitleShow.text = T.SetFontString(TitleShow, C.media.uffont, 20)
	TitleShow.text:Point("CENTER", 0, 0)
	TitleShow.text:SetText("|cffFFFFFF+|r")


-- ***** Remove Static Text ***** --
noData:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 0, 0)
noData:SetTextColor(1, 1, 1, 0)

-- ***** Set Anchor ***** --
tdpsAnchor:SetMovable(0)
tdpsAnchor:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, 3)
tdpsAnchor:SetParent(Title)

-- ***** Actual Data Frame ***** --
tdpsFrame:ClearAllPoints()
tdpsFrame:SetPoint('TOP', BG, 'TOP', 0, 0)
tdpsFrame:SetParent(BG)
tdpsFrame:SetWidth(BG:GetWidth())
tdpsFrame:SetHeight(BG:GetHeight())
tdpsFrame:SetBackdropBorderColor(0,0,0,0)
tdpsFrame:SetBackdropColor(0,0,0,0)
tdpsFrame:SetTemplate("Transparent", true)
tdpsFrame:CreateShadow("Default")

-- ***** Title Text ***** --
tdpsFrame:CreateFontString('Data', 'OVERLAY')
	Data:SetFont(tdpsFont.name, tdpsFont.size)
	Data:SetPoint('CENTER', Title, 'CENTER', 0, 0)
	Data:SetTextColor(1, 1, .5, 1)
	Data:SetText('TinyDPS')
end)
