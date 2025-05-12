local Image = {}
Image.__index = Image

function Image.new(settings)
	local instance   = setmetatable({}, Image)
	instance.id      = settings.id or nil
	instance.label   = settings.label or ""
	instance.type    = "image"
	instance.image   = settings.image
	instance.x       = settings.x or 0
	instance.y       = settings.y or 0
	instance.w       = settings.image:getWidth()
	instance.h       = settings.image:getHeight()
	instance.color   = settings.color or { 1, 1, 1, 1 }
	instance.enabled = settings.enabled ~= false
	return instance
end

function Image:getDimensions()
	return { w = self.w, h = self.h }
end

function Image:getPosition()
	return { x = self.x, y = self.y }
end

function Image:update(dt)

end

function Image:draw()
	love.graphics.setColor(self.color)
	love.graphics.draw(self.image, self.x, self.y)
end

return Image
