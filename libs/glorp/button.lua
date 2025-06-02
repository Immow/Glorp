local Button = {}
Button.__index = Button

function Button.new(settings)
	local instance     = setmetatable({}, Button)
	instance.id        = settings.id or nil
	instance.type      = "button"
	instance.x         = settings.x or 0
	instance.y         = settings.y or 0
	instance.w         = settings.w or 100
	instance.h         = settings.h or 30
	instance.label     = settings.label or ""
	instance.pressed   = false
	instance.hovered   = false
	instance.alignment = {
		horizontal = settings.alignment and settings.alignment.horizontal or "center",
		vertical = settings.alignment and settings.alignment.vertical or "center"
	}
	instance.font      = settings.font or love.graphics:getFont()
	instance.onRelease = settings.onRelease or function() print(instance.label) end
	instance.enabled   = settings.enabled ~= false
	return instance
end

function Button:isMouseOnButton(mx, my)
	return mx >= self.x and mx <= self.x + self.w
		and my >= self.y and my <= self.y + self.h
end

function Button:mousepressed(mx, my, button)
	if button == 1 and self:isMouseOnButton(mx, my) and self.enabled then
		self.pressed = true
	end
end

function Button:mousereleased(mx, my, button)
	if button == 1 and self.pressed then
		if self:isMouseOnButton(mx, my) and self.enabled then
			self:onRelease()
		end
		self.pressed = false
	end
end

function Button:getDimensions()
	return { w = self.w, h = self.h }
end

function Button:getPosition()
	return { x = self.x, y = self.y }
end

function Button:update(dt)
	local mx, my = love.mouse.getPosition()
	self.hovered = mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h
end

function Button:draw()
	if self.hovered then
		love.graphics.setColor(0.2, 0.6, 1, 0.2) -- hover background
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end

	love.graphics.setColor(1, 1, 1, 1) -- reset color
	local textHeight = self.font:getHeight()
	local textY = self.y

	if self.alignment.vertical == "center" then
		textY = self.y + (self.h - textHeight) / 2
	elseif self.alignment.vertical == "bottom" then
		textY = self.y + self.h - textHeight
	end

	love.graphics.printf(self.label, self.x, textY, self.w, self.alignment.horizontal)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Button
