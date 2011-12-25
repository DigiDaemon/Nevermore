local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local MicroButtons = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	AchievementMicroButton,
	QuestLogMicroButton,
	GuildMicroButton,
	PVPMicroButton,
	LFDMicroButton,
	RaidMicroButton,
	EJMicroButton,
	RaidMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
}
  
-- ***** Place Micro Menu Buttons ***** --
local function MoveMicroButtons(skinName)
	for _, f in pairs(MicroButtons) do
		f:SetParent(NevermoreMicroMenu)
		f:ClearAllPoints()
		f:SetScale(T.Scale(1)*.55)
		f:SetAlpha(1)
	end
	CharacterMicroButton:SetPoint("BOTTOMLEFT", NevermoreMicroMenu, "BOTTOMLEFT", 2, 2)
	SpellbookMicroButton:SetPoint("LEFT", CharacterMicroButton, "RIGHT", 0, 0)
	TalentMicroButton:SetPoint("LEFT", SpellbookMicroButton, "RIGHT", 0, 0)            
	AchievementMicroButton:SetPoint("LEFT", TalentMicroButton, "RIGHT", 0, 0)
	QuestLogMicroButton:SetPoint("LEFT", AchievementMicroButton, "RIGHT", 0, 0)  
	GuildMicroButton:SetPoint("LEFT", QuestLogMicroButton, "RIGHT", 0, 0)
	PVPMicroButton:SetPoint("LEFT", GuildMicroButton, "RIGHT", 0, 0)
	LFDMicroButton:SetPoint("LEFT", PVPMicroButton, "RIGHT", 0, 0)
	EJMicroButton:SetPoint("LEFT", LFDMicroButton, "RIGHT", 0, 0)
	RaidMicroButton:SetPoint("LEFT", EJMicroButton, "RIGHT", 0, 0)
	MainMenuMicroButton:SetPoint("LEFT", RaidMicroButton, "RIGHT", 0, 0)
	HelpMicroButton:SetPoint("LEFT", MainMenuMicroButton, "RIGHT", 0, 0)
end
hooksecurefunc("VehicleMenuBar_MoveMicroButtons", MoveMicroButtons) -- Stop the vehicle UI from moving them back please
  MoveMicroButtons()
