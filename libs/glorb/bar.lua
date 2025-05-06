local Bar = {}
Bar.__index = Bar

function Bar.new(settings)
	local instance = setmetatable({}, Bar)

	local scrollDirection = settings.scrollDirection
	local scrollBar = settings.scrollBar or {}
	local bar = scrollBar.bar or {}

	instance.image = bar.image or nil

	local defaultW = (scrollDirection == "vertical") and 20 or 50
	local defaultH = (scrollDirection == "vertical") and 50 or 20

	instance.w = bar.w or defaultW
	instance.h = bar.h or defaultH

	if instance.image then
		instance.w = settings.image:getWidth()
		instance.h = settings.image:getHeight()
	end

	instance.color = bar.color or { 0.5, 0.5, 0.5, 0.9 }

	-- Show scrollbar unless explicitly set to false
	instance.showScrollBar = (bar.showScrollBar == nil) and true or bar.showScrollBar

	return instance
end

function Bar:draw(x, y)
	if self.showScrollBar then
		if self.image then
			love.graphics.draw(self.image, x, y)
		else
			love.graphics.setColor(self.color)
			love.graphics.rectangle("fill", x, y, self.w, self.h)
		end
	end
end

return Bar
