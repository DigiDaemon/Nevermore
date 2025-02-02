local T, C, L = unpack(select(2, ...))

if not C.auras.player then return end

local frame = NevermoreAuras
local content = NevermoreAuras.content

for _, frame in next, {
"NevermoreAurasPlayerBuffs",
"NevermoreAurasPlayerDebuffs",
"NevermoreAurasPlayerConsolidate",
} do
local header

local wrap
if T.lowversion then
wrap = 8
else
wrap = 15
end

if(frame == "NevermoreAurasPlayerConsolidate") then
header = CreateFrame("Frame", frame, UIParent, "SecureFrameTemplate")
header:SetAttribute("wrapAfter", 1)
header:SetAttribute("wrapYOffset", -35)
else
header = CreateFrame("Frame", frame, UIParent, "SecureAuraHeaderTemplate")
header:SetClampedToScreen(true)
header:SetMovable(true)
header:SetAttribute("minHeight", 30)
header:SetAttribute("wrapAfter", wrap)
header:SetAttribute("wrapYOffset", -47.5)
header:SetAttribute("xOffset", -35)
end
header:SetAttribute("minWidth", wrap * 35)
header:SetAttribute("template", "NevermoreAurasAuraTemplate")
header:SetAttribute("weaponTemplate", "NevermoreAurasAuraTemplate")
header:SetSize(30, 30)

-- Swap the unit to vehicle when we enter a vehicle *gasp*.
RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")

table.insert(content, header)
end

local buffs = NevermoreAurasPlayerBuffs
local debuffs = NevermoreAurasPlayerDebuffs
local consolidate = NevermoreAurasPlayerConsolidate
local filter = 0

if C.auras.consolidate then
filter = 1
end

-- set our buff header
buffs:SetPoint("TOPRIGHT", UIParent, -(MinimapBackdrop:GetWidth() - (T.buttonsize + (T.buttonspacing * 3))), -T.buttonsize)
buffs:SetAttribute("filter", "HELPFUL")
buffs:SetAttribute("consolidateProxy", CreateFrame("Frame", buffs:GetName() .. "ProxyButton", buffs, "NevermoreAurasProxyTemplate"))
buffs:SetAttribute("consolidateHeader", consolidate)

-- blizzard introduced bugs with secure aura headers in 4.3, disabling it until fixed
if T.toc < 40300 then
buffs:SetAttribute("consolidateTo", filter)
buffs:SetAttribute("includeWeapons", 1)
end

buffs:SetAttribute("consolidateDuration", -1)
buffs:Show()

-- create the consolidated button
local proxy = buffs:GetAttribute("consolidateProxy")
proxy:HookScript("OnShow", function(self) if consolidate:IsShown() then consolidate:Hide() end end) -- kind of bug fix for secure aura header

-- create the dropdown and register click
local dropdown = CreateFrame("BUTTON", "NevermoreAurasPlayerConsolidateDropdownButton", proxy, "SecureHandlerClickTemplate")
dropdown:SetAllPoints()
dropdown:RegisterForClicks("AnyUp")
dropdown:SetAttribute("_onclick", [=[
local header = self:GetParent():GetFrameRef"header"

local numChild = 0
repeat
numChild = numChild + 1
local child = header:GetFrameRef("child" .. numChild)
until not child or not child:IsShown()

numChild = numChild - 1

-- needed, else the dropdown is not positionned correctly on opening
local x, y = self:GetWidth(), self:GetHeight()
header:SetWidth(x)
header:SetHeight(y)
if header:IsShown() then
header:Hide()
else
header:Show()
end
]=]);

-- set our consolidate header
consolidate:SetAttribute("point", "RIGHT")
consolidate:SetAttribute("minHeight", nil)
consolidate:SetAttribute("minWidth", nil)
consolidate:SetParent(proxy)
consolidate:ClearAllPoints()
consolidate:SetPoint("CENTER", proxy, "CENTER", 0, -35)
consolidate:Hide()
SecureHandlerSetFrameRef(proxy, "header", consolidate)

-- set our debuff header
debuffs:SetPoint("TOP", buffs, "BOTTOM", 0, -84)
debuffs:SetAttribute("filter", "HARMFUL")
debuffs:Show()
