local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--[[
	Thx to Tulla
		Adds out of range coloring to action buttons
		Derived from RedRange and TullaRange
--]]

if not C["actionbar"].enable == true then return end

--locals and speed
local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = ATTACK_BUTTON_FLASH_TIME
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction

--code for handling defaults
local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == 'table' and type(v) == 'table' then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end
	return tbl
end

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end
	return tbl
end

local function timer_Create(parent, interval)
	local updater = parent:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self)
		if parent:Update() then
			parent:Start(interval)
		end
	end)

	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)

	parent.Start = function(self)
		self:Stop()
		a:SetDuration(interval)
		updater:Play()
		return self
	end

	parent.Stop = function(self)
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	parent.Active = function(self)
		return updater:IsPlaying()
	end

	return parent
end

--stuff for holy power detection
local PLAYER_IS_PALADIN = select(2, UnitClass('player')) == 'PALADIN'
local HAND_OF_LIGHT = GetSpellInfo(90174)
local isHolyPowerAbility
do
	local HOLY_POWER_SPELLS = {
		[85256] = GetSpellInfo(85256), --Templar's Verdict
		[53600] = GetSpellInfo(53600), --Shield of the Righteous
		-- [84963] = GetSpellInfo(84963), --Inquisition
		-- [85673] = GetSpellInfo(85673), --Word of Glory
		-- [85222] = GetSpellInfo(85222), --Light of Dawn
	}

	isHolyPowerAbility = function(actionId)
		local actionType, id = GetActionInfo(actionId)
		if actionType == 'macro' then
			local macroSpell = GetMacroSpell(id)
			if macroSpell then
				for spellId, spellName in pairs(HOLY_POWER_SPELLS) do
					if macroSpell == spellName then
						return true
					end
				end
			end
		else
			return HOLY_POWER_SPELLS[id]
		end
		return false
	end
end

--[[ The main thing ]]--
local NevermoreRange = timer_Create(CreateFrame('Frame', 'NevermoreRange'), UPDATE_DELAY)

function NevermoreRange:Load()
	self:SetScript('OnEvent', self.OnEvent)
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('PLAYER_LOGOUT')
end


--[[ Frame Events ]]--
function NevermoreRange:OnEvent(event, ...)
	local action = self[event]
	if action then
		action(self, event, ...)
	end
end

--[[ Game Events ]]--
function NevermoreRange:PLAYER_LOGIN()
	if not NevermoreRange_COLORS then
		NevermoreRange_COLORS = {}
	end
	self.colors = copyDefaults(NevermoreRange_COLORS, self:GetDefaults())

	--add options loader
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('NevermoreRange_Config')
	end)

	self.buttonsToUpdate = {}

	hooksecurefunc('ActionButton_OnUpdate', self.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', self.OnUpdateButtonUsable)
	hooksecurefunc('ActionButton_Update', self.OnButtonUpdate)
end

function NevermoreRange:PLAYER_LOGOUT()
	removeDefaults(NevermoreRange_COLORS, self:GetDefaults())
end

--[[ Actions ]]--
function NevermoreRange:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function NevermoreRange:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		NevermoreRange.OnUpdateButtonUsable(button)
	end
end

function NevermoreRange:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function NevermoreRange:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function NevermoreRange:UpdateButton(button, elapsed)
	NevermoreRange.UpdateButtonUsable(button)
	NevermoreRange.UpdateFlash(button, elapsed)
end

function NevermoreRange:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end

--[[ Button Hooking ]]--
function NevermoreRange.RegisterButton(button)
	button:HookScript('OnShow', NevermoreRange.OnButtonShow)
	button:HookScript('OnHide', NevermoreRange.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	NevermoreRange:UpdateButtonStatus(button)
end

function NevermoreRange.OnButtonShow(button)
	NevermoreRange:UpdateButtonStatus(button)
end

function NevermoreRange.OnButtonHide(button)
	NevermoreRange:UpdateButtonStatus(button)
end

function NevermoreRange.OnUpdateButtonUsable(button)
	button.NevermoreRangeColor = nil
	NevermoreRange.UpdateButtonUsable(button)
end

function NevermoreRange.OnButtonUpdate(button)
	 NevermoreRange:UpdateButtonStatus(button)
end

--[[ Range Coloring ]]--
function NevermoreRange.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			NevermoreRange.SetButtonColor(button, 'oor')
		--a holy power abilty, and we're less than 3 Holy Power
		elseif PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) == 3 or UnitBuff('player', HAND_OF_LIGHT)) then
			NevermoreRange.SetButtonColor(button, 'ooh')
		--in range
		else
			NevermoreRange.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		NevermoreRange.SetButtonColor(button, 'oom')
	--unusable
	else
		button.NevermoreRangeColor = 'unusuable'
	end
end

function NevermoreRange.SetButtonColor(button, colorType)
	if button.NevermoreRangeColor ~= colorType then
		button.NevermoreRangeColor = colorType

		local r, g, b = NevermoreRange:GetColor(colorType)

		local icon =  _G[button:GetName() .. 'Icon']
		icon:SetVertexColor(r, g, b)
	end
end

function NevermoreRange.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName() .. 'Flash']
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end


--[[ Configuration ]]--
function NevermoreRange:GetDefaults()
	return {
		normal = {1, 1, 1},
		oor = {1, 0.1, 0.1},
		oom = {0.1, 0.3, 1},
		ooh = {0.45, 0.45, 1},
	}
end

function NevermoreRange:Reset()
	NevermoreRange_COLORS = {}
	self.colors = copyDefaults(NevermoreRange_COLORS, self:GetDefaults())

	self:ForceColorUpdate()
end

function NevermoreRange:SetColor(index, r, g, b)
	local color = self.colors[index]
	color[1] = r
	color[2] = g
	color[3] = b

	self:ForceColorUpdate()
end

function NevermoreRange:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end

--[[ Load The Thing ]]--
NevermoreRange:Load()
