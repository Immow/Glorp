local Button = {}
Button.__index = Button

function Button.new(settings)
	local instance     = setmetatable({}, Button)
	instance.x         = settings.x or 0
	instance.y         = settings.y or 0
	instance.w         = settings.w or 100
	instance.h         = settings.h or 50
	instance.label     = settings.label or ""
	instance.alignment = {
		horizontal = settings.alignment and settings.alignment.horizontal or "center",
		vertical = settings.alignment and settings.alignment.vertical or "center"
	}
	instance.font      = settings.font or love.graphics:getFont()
	return instance
end

function Button:getDimensions()
	return { w = self.w, h = self.h }
end

function Button:getPosition()
	return { x = self.x, y = self.y }
end

function Button:update(dt)

end

function Button:draw()
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
