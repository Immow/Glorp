local Button = {}
Button.__index = Button

function Button.new(settings)
	local instance = setmetatable({}, Button)
	instance.x     = settings.x or 0
	instance.y     = settings.y or 0
	instance.w     = settings.w or 100
	instance.h     = settings.h or 50
	instance.label = settings.label or ""
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
	love.graphics.printf(self.label, self.x, self.y, self.w, "center")
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Button
