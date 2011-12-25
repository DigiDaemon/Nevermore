local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-----------------------------------------------------------------------------
-- Copy on chatframes feature
-----------------------------------------------------------------------------

if C["chat"].enable ~= true then return end

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "NevermoreChatCopyFrame", UIParent)
	frame:SetTemplate("Default")
	frame:Width(NevermoreCenter:GetWidth())
	frame:Height(NevermoreCenter:GetHeight())
	frame:SetScale(1)
	frame:Point("BOTTOM", NevermoreCenter, "BOTTOM", 0, 0)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "NevermoreChatCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -T.buttonsize, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:Width(NevermoreCenter:GetWidth())
	editBox:Height(NevermoreCenter:GetHeight())
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	T.SkinCloseButton(close)
	T.SkinScrollBar(NevermoreChatCopyScrollScrollBar)

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

local function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("NevermoreButtonCF%d", i), cf)
		button:SetPoint("TOPRIGHT", T.buttonsize + 1, 0)
		button:Height(24)
		button:Width(T.buttonsize)
		button:SetNormalTexture(C.media.copyicon)
		button:SetAlpha(1)
		button:SetTemplate("Default")

		button:SetScript("OnMouseUp", function(self)
			Copy(cf)
		end)
		button:SetScript("OnEnter", function() 
			button:SetAlpha(1) 
		end)
		button:SetScript("OnLeave", function() button:SetAlpha(1) end)
	end
end
ChatCopyButtons()
