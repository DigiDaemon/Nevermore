-----------------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------------
local tex = "Interface\\AddOns\\oUF_Itrulia\\media\\texture"
local font = "Fonts\\ARIALN.ttf"
local fontsize = 12
local tags = "THINOUTLINE"
_, class = UnitClass("player")

-- setup ingame config Oo
unitframeconfig = {
	["Font"] = font,
	["Font size"] = fontsize,
	["Font style"] = tags,
	["Statusbar Texture"] = tex,
}
if UIConfig then
	UIConfig["Unit frames"] = unitframeconfig
end