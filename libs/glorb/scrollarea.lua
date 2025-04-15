local folder_path = (...):match("(.-)[^%.]+$")
local Button = require(folder_path .. "button")

local ScrollArea = {}
ScrollArea.__index = ScrollArea

function ScrollArea.new(settings)
	local instance       = setmetatable({}, ScrollArea)
	instance.y           = settings.y or 0
	instance.x           = settings.x or 0
	instance.w           = settings.w or 200
	instance.h           = settings.h or error("scrollArea needs a height")
	instance.label       = settings.label or ""
	instance.buttonLabel = settings.buttonLabel
	instance.scrollY     = 0
	instance.buttonHeigh = settings.buttonHeigh or 50
	instance.spacing     = settings.spacing or 10
	instance.size        = settings.size
	instance.children    = {}

	local yStart         = instance.y
	for i = 1, settings.size do
		instance.children[i] = Button.new({
			x = instance.x,
			y = yStart,
			w = 200,
			h = 50,
			label = (instance.buttonLabel ~= "" and instance.buttonLabel .. " " .. i or tostring(i))
		})
		yStart = yStart + instance.spacing + instance.buttonHeigh
	end

	return instance
end

function ScrollArea:isMouseOnScrollArea(mx, my)
	local xRegion = self.x <= mx and self.x + self.w >= mx
	local yRegion = self.y <= my and self.y + self.h >= my
	return xRegion and yRegion
end

function ScrollArea:getDimensions()
	return { w = self.w, h = self.h }
end

function ScrollArea:getHeight()
	return self.h
end

function ScrollArea:getPosition()
	return { x = self.x, y = self.y }
end

function ScrollArea:update(dt)

end

function ScrollArea:draw()
	love.graphics.setScissor(self.x, self.y, self.w, self.h)
	love.graphics.push()
	love.graphics.translate(0, -self.scrollY)

	for _, child in ipairs(self.children) do
		if child.draw then
			child:draw()
		end
	end

	love.graphics.pop()
	love.graphics.setScissor()
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function ScrollArea:mousepressed(x, y, button)
	local localY = y + self.scrollY
	for _, child in ipairs(self.children) do
		if child.mousepressed then
			child:mousepressed(x, localY, button)
		end
	end
end

function ScrollArea:wheelmoved(x, y)
	self.scrollY = self.scrollY - y * 20

	if self.scrollY < 0 then
		self.scrollY = 0
	end

	local contentHeight = #self.children * (self.buttonHeigh + self.spacing) - self.spacing
	local maxScroll = math.max(0, contentHeight - self.h)

	if self.scrollY > maxScroll then
		self.scrollY = maxScroll
	end
end

return ScrollArea
