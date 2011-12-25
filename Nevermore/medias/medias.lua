local T, C, L = unpack(select(2, ...))

C["media"] = {
	-- fonts (ENGLISH, SPANISH)
	["fontsizenorm"] = 12,
	["fonttnoutline"] = 'THINOUTLINE',
	["font"] = [=[Interface\Addons\Nevermore\medias\fonts\normal_font.ttf]=], -- general font of Nevermore
	["uffont"] = [[Interface\AddOns\Nevermore\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["dmgfont"] = [[Interface\AddOns\Nevermore\medias\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (DEUTSCH)
	["de_font"] = [=[Interface\Addons\Nevermore\medias\fonts\normal_font.ttf]=], -- general font of Nevermore
	["de_uffont"] = [[Interface\AddOns\Nevermore\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["de_dmgfont"] = [[Interface\AddOns\Nevermore\medias\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (FRENCH)
	["fr_font"] = [=[Interface\Addons\Nevermore\medias\fonts\normal_font.ttf]=], -- general font of Nevermore
	["fr_uffont"] = [[Interface\AddOns\Nevermore\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["fr_dmgfont"] = [=[Interface\AddOns\Nevermore\medias\fonts\combat_font.ttf]=], -- general font of dmg / sct
	
	-- fonts (RUSSIAN)
	["ru_font"] = [=[Interface\Addons\Nevermore\medias\fonts\normal_font.ttf]=], -- general font of Nevermore
	["ru_uffont"] = [[Fonts\ARIALN.TTF]], -- general font of unitframes
	["ru_dmgfont"] = [[Interface\AddOns\Nevermore\medias\fonts\combat_font_rus.ttf]], -- general font of dmg / sct
	
	-- fonts (TAIWAN ONLY)
	["tw_font"] = [=[Fonts\bLEI00D.ttf]=], -- general font of Nevermore
	["tw_uffont"] = [[Fonts\bLEI00D.ttf]], -- general font of unitframes
	["tw_dmgfont"] = [[Fonts\bLEI00D.ttf]], -- general font of dmg / sct
	
	-- fonts (KOREAN ONLY)
	["kr_font"] = [=[Fonts\2002.TTF]=], -- general font of Nevermore
	["kr_uffont"] = [[Fonts\2002.TTF]], -- general font of unitframes
	["kr_dmgfont"] = [[Fonts\2002.TTF]], -- general font of dmg / sct
	
	["cn_font"] = [=[Fonts\ZYKai_T.TTF]=], -- general font of Nevermore
	["cn_uffont"] = [[Fonts\ZYHei.TTF]], -- general font of unitframes
	["cn_dmgfont"] = [[Fonts\ZYKai_C.TTF]], -- general font of dmg / sct
	
	-- fonts (GLOBAL)
	["pixelfont"] = [=[Interface\Addons\Nevermore\medias\fonts\pixel_font.ttf]=], -- general font of Nevermore
	
	-- textures
	["normTex"] = [[Interface\AddOns\Nevermore\medias\textures\normTex]], -- texture used for Nevermore healthbar/powerbar/etc
	["glowTex"] = [[Interface\AddOns\Nevermore\medias\textures\glowTex]], -- the glow text around some frame.
	["bubbleTex"] = [[Interface\AddOns\Nevermore\medias\textures\bubbleTex]], -- unitframes combo points
	["copyicon"] = [[Interface\AddOns\Nevermore\medias\textures\copy]], -- copy icon
	["blank"] = [[Interface\AddOns\Nevermore\medias\textures\blank]], -- the main texture for all borders/panels
	["buttonhover"] = [[Interface\AddOns\Nevermore\medias\textures\button_hover]],
	
	-- colors
	["bordercolor"] = C.general.bordercolor or { .6,.6,.6 }, -- border color of Nevermore panels
	["backdropcolor"] = C.general.backdropcolor or { 0,0,0 }, -- background color of Nevermore panels
	["datatextcolor1"] = { 1, 1, 1 }, -- color of datatext title
	["datatextcolor2"] = { 1, 1, 1 }, -- color of datatext result
	
	-- sound
	["whisper"] = [[Interface\AddOns\Nevermore\medias\sounds\whisper.mp3]],
	["warning"] = [[Interface\AddOns\Nevermore\medias\sounds\warning.mp3]],
}

-------------------------------------------------------------------
-- Used to overwrite default medias outside Nevermore
-------------------------------------------------------------------

local settings = NevermoreEditedDefaultConfig
if settings then
	local media = settings.media
	if media then
		for option, value in pairs(media) do
			C.media[option] = value
		end
	end
end
