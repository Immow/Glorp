local RadioButton = {}
RadioButton.__index = RadioButton

function RadioButton.new(settings)
	local instance      = setmetatable({}, RadioButton)
	instance.label      = settings.label or "label"
	instance.font       = settings.font or love.graphics.getFont()
	instance.radius     = settings.radius or 8
	instance.x          = settings.x or 0
	instance.y          = settings.y or 0
	instance.spacing    = settings.spacing or 5
	instance.w          = settings.w or instance.font:getWidth(instance.label) + instance.radius * 2 + instance.spacing
	instance.h          = settings.h or instance.font:getHeight()
	instance.checkInset = settings.checkInset or 3
	instance.checked    = settings.checked or false
	instance.onRelease  = settings.onRelease or nil
	return instance
end

function RadioButton:containsPoint(mx, my)
	local cx = self.x + self.radius
	local cy = self.y + self.radius
	local dx = mx - cx
	local dy = my - cy
	return dx * dx + dy * dy <= self.radius * self.radius
end

function RadioButton:mousepressed(x, y, button, isTouch)
	if button == 1 and self:containsPoint(x, y) then
		self.checked = not self.checked
		if self.onRelease then
			self.onRelease(self.checked)
		end
	end
end

function RadioButton:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("line", self.x + self.radius, self.y + self.radius, self.radius)
	love.graphics.print(self.label, self.x + self.radius * 2 + self.spacing, self.y)
	if self.checked then
		love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, self.radius - self.checkInset)
	end

	-- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return RadioButton
