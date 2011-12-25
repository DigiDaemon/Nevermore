local T, C, L = unpack(select(2, ...))

-- Media
C.blank = [[Interface\AddOns\Tukui_SUI\modules\chat\HydraChat\media\blank]]
C.font = [=[Interface\AddOns\Tukui_SUI\modules\chat\HydraChat\media\font.ttf]=]

-- Functions, credit Tukui (Tukz / nightcracker)

local UIscale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIscale
local Scale = function(x)
    return mult*math.floor(x/mult+.5)
end

--T.Scale = function(x) return Scale(x) end

--[[F.CreatePanel = function(f, w, h, a1, p, a2, x, y)
	local sh = Scale(h)
	local sw = Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, Scale(x), Scale(y))
	f:SetBackdrop({
	  bgFile = C.blank, 
	  edgeFile = C.blank, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	
	f:SetBackdropColor(unpack(C["General"].BackdropColor))
	f:SetBackdropBorderColor(unpack(C["General"].BorderColor))
end]]--

T.Kill = function(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	
	object.Show = function() end
	object:Hide()
end

local waitTable = {}
local waitFrame
T.Delay = function(delay, func, ...)
	if (type(delay) ~= "number" or type(func) ~= "function") then
		return false
	end
	
	if (waitFrame == nil) then
		waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
		waitFrame:SetScript("OnUpdate", function (self, elapse)
			local count = #waitTable
			local i = 1
			while (i <= count) do
				local waitRecord = tremove(waitTable, i)
				local d = tremove(waitRecord, 1)
				local f = tremove(waitRecord, 1)
				local p = tremove(waitRecord, 1)
				if(d > elapse) then
					tinsert(waitTable, i, {d-elapse, f, p})
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
	end
	
	tinsert(waitTable, {delay, func, {...}})
	return true
end
