local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C.tooltip.enable ~= true then return end

GameTooltip:HookScript("OnTooltipCleared", function(self) self.NevermoreItemTooltip = nil end)
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if (IsShiftKeyDown() or IsAltKeyDown()) and (NevermoreItemTooltip and not self.NevermoreItemTooltip and (NevermoreItemTooltip.id or NevermoreItemTooltip.count)) then
		local item, link = self:GetItem()
		local num = GetItemCount(link)
		local left = ""
		local right = ""
		
		if NevermoreItemTooltip.id and link ~= nil then
			left = "|cFFCA3C3CID|r "..link:match(":(%w+)")
		end
		
		if NevermoreItemTooltip.count and num > 1 then
			right = "|cFFCA3C3C"..L.tooltip_count.."|r "..num
		end
				
		self:AddLine(" ")
		self:AddDoubleLine(left, right)
		self.NevermoreItemTooltip = 1
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "Nevermore" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	NevermoreItemTooltip = NevermoreItemTooltip or {count=true, id=true}
end)
