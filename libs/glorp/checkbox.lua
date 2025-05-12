local CheckBox = {}
CheckBox.__index = CheckBox

function CheckBox.new(settings)
	local instance      = setmetatable({}, CheckBox)
	instance.boxWidth   = settings.boxWidth or 20
	instance.boxHeight  = settings.boxHeight or 20
	instance.x          = settings.x or 0
	instance.y          = settings.y or 0
	instance.w          = instance.boxWidth
	instance.h          = instance.boxHeight
	instance.checkInset = settings.checkInset or 3
	instance.checked    = settings.checked or false
	instance.onRelease  = settings.onRelease or nil
	instance.enabled    = settings.enabled ~= false
	return instance
end

function CheckBox:containsPoint(mx, my)
	return mx >= self.x and mx <= self.x + self.w
		and my >= self.y and my <= self.y + self.h
end

function CheckBox:mousepressed(x, y, button, isTouch)
	if not self.enabled then return end
	if button == 1 and self:containsPoint(x, y) then
		self.checked = not self.checked
		if self.onRelease then
			self.onRelease(self.checked)
		end
	end
end

function CheckBox:draw()
	if not self.enabled then return end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if self.checked then
		local inset = self.checkInset
		love.graphics.rectangle("fill",
			self.x + inset,
			self.y + inset,
			self.w - 2 * inset,
			self.h - 2 * inset
		)
	end
end

return CheckBox
