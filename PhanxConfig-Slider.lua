--[[--------------------------------------------------------------------
	PhanxConfig-Slider
	Simple slider widget generator.
	Based on tekKonfig-Slider and AceGUI-3.0-Slider.
	Requires LibStub.

	This library is not intended for use by other authors. Absolutely no
	support of any kind will be provided for other authors using it, and
	its internals may change at any time without notice.
----------------------------------------------------------------------]]

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-Slider", 3)
if not lib then return end

local function OnEnter(self)
	if self.desc then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.desc, nil, nil, nil, nil, true)
	end
end

local function OnLeave()
	GameTooltip:Hide()
end

local function OnMouseWheel(self, delta)
	local step = self:GetValueStep() * delta
	local minValue, maxValue = self:GetMinMaxValues()

	if step > 0 then
		self:SetValue(min(self:GetValue() + step, maxValue))
	else
		self:SetValue(max(self:GetValue() + step, minValue))
	end
end

local function OnValueChanged(self)
	local value = self.OnValueChanged and self:OnValueChanged(self:GetValue())
	if not value then
		value = self:GetValue()
	end
	if self.isPercent then
		self.valueText:SetFormattedText(self.valueFormat or "%d%%", value * 100)
	else
		self.valueText:SetFormattedText(self.valueFormat or "%d", value)
	end
end

local sliderBG = {
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	edgeSize = 8, tile = true, tileSize = 8,
	insets = { left = 3, right = 3, top = 6, bottom = 6 }
}

function lib.CreateSlider(parent, name, lowvalue, highvalue, valuestep, percent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(144)
	frame:SetHeight(42)

--	local bg = frame:CreateTexture(nil, "BACKGROUND")
--	bg:SetAllPoints(frame)
--	bg:SetTexture(0, 0, 0)

	local slider = CreateFrame("Slider", nil, frame)
	slider:SetPoint("LEFT", 5, 0)
	slider:SetPoint("RIGHT", -5, 0)
	slider:SetHeight(17)
	slider:SetHitRectInsets(0, 0, -10, -10)
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	slider:SetBackdrop(sliderBG)

	local label = slider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT")
	label:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT")
	label:SetJustifyH("LEFT")
	label:SetText(name)

	local low = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, 3)
	if percent then
		low:SetFormattedText("%d%%", lowvalue * 100)
	else
		low:SetText(lowvalue)
	end

	local high = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	high:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, 3)
	if percent then
		high:SetFormattedText("%d%%", highvalue * 100)
	else
		high:SetText(highvalue)
	end

	local value = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	value:SetPoint("TOP", slider, "BOTTOM", 0, 3)
	value:SetTextColor(1, 0.8, 0)

	slider:EnableMouseWheel(true)
	slider:SetMinMaxValues(lowvalue, highvalue)
	slider:SetValueStep(valuestep or 1)

	slider:SetScript("OnEnter", OnEnter)
	slider:SetScript("OnLeave", OnLeave)
	slider:SetScript("OnMouseWheel", OnMouseWheel)
	slider:SetScript("OnValueChanged", OnValueChanged)

	slider.isPercent = percent

	slider.container = frame
	slider.label = label
	slider.lowText = low
	slider.highText = high
	slider.valueText = value

	return slider
end