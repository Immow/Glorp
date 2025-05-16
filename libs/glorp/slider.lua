local Slider = {}
Slider.__index = Slider

function Slider.new(settings)
	local instance           = setmetatable({}, Slider)
	instance.type            = "slider"
	instance.id              = settings.id or nil
	instance.orientation     = settings.orientation or "horizontal"
	instance.knob_w          = settings.knob_w or 20
	instance.knob_h          = settings.knob_h or 20
	instance.x               = settings.x or 0
	instance.y               = settings.y or 0
	instance.w               = settings.w or 100
	instance.h               = settings.h or 40
	instance.value           = math.max(0, math.min(settings.value or 0, 1))
	instance.groove_h        = settings.groove_h or 8
	instance.sliderRangeMax  = settings.sliderRangeMax or 1
	instance.sliderRangeMin  = settings.sliderRangeMin or 0
	instance.active          = false
	instance.grooveColor     = settings.grooveColor or { 0.3, 0.3, 0.3 }
	instance.knobColor       = settings.knobColor or { 1, 1, 1 }
	instance.knobBorderColor = settings.knobBorderColor or { 0, 0, 0 }
	instance.onRelease       = settings.onRelease or nil

	instance.start_x         = instance.x
	instance.start_y         = instance.y
	instance.enabled         = settings.enabled ~= false

	return instance
end

function Slider:getValue()
	if self.orientation == "horizontal" then
		local value = self.sliderRangeMin +
			((self.knob_x - self.x) / (self.w - self.knob_w)) * (self.sliderRangeMax - self.sliderRangeMin)
		return math.max(self.sliderRangeMin, math.min(self.sliderRangeMax, value))
	else
		local value = self.sliderRangeMin +
			((self.knob_y - self.y) / (self.h - self.knob_h)) * (self.sliderRangeMax - self.sliderRangeMin)
		return math.max(self.sliderRangeMin, math.min(self.sliderRangeMax, value))
	end
end

function Slider:containsPointKnob(x, y)
	if self.orientation == "horizontal" then
		local knob_y = self.y + self.h / 2 - self.knob_h / 2
		return x >= self.knob_x and x <= self.knob_x + self.knob_w and y >= knob_y and y <= knob_y + self.knob_h
	else
		local knob_x = self.x + self.w / 2 - self.knob_w / 2
		return x >= knob_x and x <= knob_x + self.knob_w and y >= self.knob_y and y <= self.knob_y + self.knob_h
	end
end

function Slider:containsPointGroove(x, y)
	if self.orientation == "horizontal" then
		local groove_y = self.y + self.h / 2 - self.groove_h / 2
		return x >= self.x and x <= self.x + self.w and y >= groove_y and y <= groove_y + self.groove_h
	else
		local groove_x = self.x + self.w / 2 - self.groove_h / 2
		return x >= groove_x and x <= groove_x + self.groove_h and y >= self.y and y <= self.y + self.h
	end
end

function Slider:mousemoved(x, y, dx, dy)
	if love.mouse.isDown(1) and self:containsPointKnob(x, y) then
		self.active = true
	end

	if self.active then
		if self.orientation == "horizontal" then
			self.knob_x = math.max(self.x, math.min(self.x + self.w - self.knob_w, self.knob_x + dx))
			-- Update startValue based on knob position
			local valuePercent = (self.knob_x - self.x) / (self.w - self.knob_w)
			self.value = self.sliderRangeMin + valuePercent * (self.sliderRangeMax - self.sliderRangeMin)
		else
			self.knob_y = math.max(self.y, math.min(self.y + self.h - self.knob_h, self.knob_y + dy))
			-- Update startValue based on knob position
			local valuePercent = (self.knob_y - self.y) / (self.h - self.knob_h)
			self.value = self.sliderRangeMin + valuePercent * (self.sliderRangeMax - self.sliderRangeMin)
		end
	end
end

function Slider:mousepressed(x, y, button)
	if button ~= 1 then return end

	if self.orientation == "horizontal" then
		if self:containsPointGroove(x, y) and not self:containsPointKnob(x, y) then
			self.knob_x = math.max(self.x, math.min(self.x + self.w - self.knob_w, x - self.knob_w / 2))
			-- Update startValue based on knob position
			local valuePercent = (self.knob_x - self.x) / (self.w - self.knob_w)
			self.value = self.sliderRangeMin + valuePercent * (self.sliderRangeMax - self.sliderRangeMin)
			self.active = true
		end
	else
		if self:containsPointGroove(x, y) and not self:containsPointKnob(x, y) then
			self.knob_y = math.max(self.y, math.min(self.y + self.h - self.knob_h, y - self.knob_h / 2))
			-- Update startValue based on knob position
			local valuePercent = (self.knob_y - self.y) / (self.h - self.knob_h)
			self.value = self.sliderRangeMin + valuePercent * (self.sliderRangeMax - self.sliderRangeMin)
			self.active = true
		end
	end
end

function Slider:setPosition(x, y)
	self.x = x
	self.y = y

	-- Recalculate knob position based on the current value
	local valuePercent = (self.value - self.sliderRangeMin) / (self.sliderRangeMax - self.sliderRangeMin)

	if self.orientation == "horizontal" then
		self.knob_x = self.x + (self.w - self.knob_w) * valuePercent
	else
		self.knob_y = self.y + (self.h - self.knob_h) * valuePercent
	end
end

function Slider:mousereleased()
	if self.active then
		self.active = false
		if self.onRelease then
			self.onRelease(self:getValue())
		end
	end
end

function Slider:drawGroove()
	love.graphics.setColor(self.grooveColor)
	if self.orientation == "horizontal" then
		local y = self.y + self.h / 2 - self.groove_h / 2
		love.graphics.rectangle("fill", self.x, y, self.w, self.groove_h)
	else
		local x = self.x + self.w / 2 - self.groove_h / 2
		love.graphics.rectangle("fill", x, self.y, self.groove_h, self.h)
	end
end

function Slider:drawKnob()
	love.graphics.setColor(self.knobColor)
	if self.orientation == "horizontal" then
		local y = self.y + self.h / 2 - self.knob_h / 2
		love.graphics.rectangle("fill", self.knob_x, y, self.knob_w, self.knob_h)
		love.graphics.setColor(self.knobBorderColor)
		love.graphics.rectangle("line", self.knob_x, y, self.knob_w, self.knob_h)
	else
		local x = self.x + self.w / 2 - self.knob_w / 2
		love.graphics.rectangle("fill", x, self.knob_y, self.knob_w, self.knob_h)
		love.graphics.setColor(self.knobBorderColor)
		love.graphics.rectangle("line", x, self.knob_y, self.knob_w, self.knob_h)
	end
	love.graphics.setColor(1, 1, 1)
end

function Slider:draw()
	self:drawGroove()
	self:drawKnob()
end

return Slider
