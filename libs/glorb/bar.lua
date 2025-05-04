local Bar = {}
Bar.__index = Bar

function Bar.new(settings)
	local instance = setmetatable({}, Bar)
	instance.id    = settings.id
	instance.x     = 0
	instance.y     = 0
	instance.image = settings.image or nil
	local defaultW = (settings.scrollDirection == "vertical") and 20 or 50
	local defaultH = (settings.scrollDirection == "vertical") and 50 or 20

	instance.w     = (settings.bar and settings.bar.w) or defaultW
	instance.h     = (settings.bar and settings.bar.h) or defaultH

	if instance.image then
		instance.w = settings.image:getWidth()
		instance.h = settings.image:getHeight()
	end

	instance.color = (settings.bar and settings.bar.color) or { 0.8, 0.8, 0.8, 0.7 }

	return instance
end

function Bar:draw(x, y)
	if self.image then
		love.graphics.draw(self.image, self.x, self.y)
	else
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end

return Bar
