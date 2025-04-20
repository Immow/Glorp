local folder_path = (...):match("(.-)[^%.]+$")
local Button = require(folder_path .. "button")

local Container = {}
Container.__index = Container

function Container.new(settings)
	local instance = setmetatable({}, Container)
	instance.id = settings.id
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.w = settings.w or 0
	instance.h = settings.h or 0
	instance.layout = settings.layout or "horizontal"
	instance.spacing = settings.spacing or 10
	instance.label = "container"
	instance.border = settings.border or true
	instance.borderColor = settings.borderColor or { 0, 0, 0, 1 }
	instance.backgroundColor = settings.backgroundColor or { 0, 0, 0, 1 }
	instance.scrollable = settings.scrollable or false
	instance.scrollY = 0
	instance.maxScrollY = 0
	instance.alignment = {
		horizontal = settings.alignment and settings.alignment.horizontal or "center",
		vertical = settings.alignment and settings.alignment.vertical or "center"
	}

	if settings.scrollable then
		instance.vertical = "top"
	end

	instance.children = {}

	return instance
end

function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	self:updateChildren()
	return self
end

function Container:updateChildren()
	local childrenTotalWidth, childrenTotalHeight = -self.spacing, -self.spacing

	for i, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			childrenTotalWidth = childrenTotalWidth + child.w + (self.spacing * (i - 1))
			childrenTotalHeight = math.max(childrenTotalHeight, child.h)
		else
			childrenTotalHeight = childrenTotalHeight + child.h + (self.spacing * (i - 1))
			childrenTotalWidth = math.max(childrenTotalWidth, child.w)
		end
	end

	self.w = math.max(self.w, childrenTotalWidth)
	if not self.scrollable then
		self.h = math.max(self.h, childrenTotalHeight)
	end
	self.maxScrollY = childrenTotalHeight - self.h

	local startX, startY
	if self.alignment.horizontal == "center" then
		startX = self.x + (self.w - childrenTotalWidth) / 2
	elseif self.alignment.horizontal == "right" then
		startX = self.x + self.w - childrenTotalWidth
	else
		startX = self.x
	end

	if self.alignment.vertical == "center" then
		startY = self.y + (self.h - childrenTotalHeight) / 2
	elseif self.alignment.vertical == "bottom" then
		startY = self.y + self.h - childrenTotalHeight
	else
		startY = self.y
	end

	local offsetX, offsetY = startX, startY
	for _, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			child.x = offsetX
			if self.alignment.vertical == "bottom" then
				child.y = self.y + self.h - child.h
			elseif self.alignment.vertical == "center" then
				child.y = self.y + (self.h - child.h) / 2
			else
				child.y = startY
			end
			offsetX = offsetX + child.w + self.spacing
		else
			child.y = offsetY
			if self.alignment.horizontal == "bottom" then
				child.x = self.x + self.w - child.w
			elseif self.alignment.horizontal == "center" then
				child.x = self.x + (self.w - child.w) / 2
			else
				child.x = startX
			end
			offsetY = offsetY + child.h + self.spacing
		end
	end
end

function Container:wheelmoved(x, y)
	if self.scrollable then
		self.scrollY = math.max(0, math.min(self.scrollY - y * 20, self.maxScrollY))
	end
end

function Container:mousepressed(mx, my, button, isTouch)
	if mx < self.x or mx > self.x + self.w or my < self.y or my > self.y + self.h then
		return
	end

	local adjustedY = my + (self.scrollable and self.scrollY or 0)
	for _, child in ipairs(self.children) do
		if child.mousepressed then
			child:mousepressed(mx, adjustedY, button, isTouch)
		end
	end
end

function Container:update(dt)
	for _, child in ipairs(self.children) do
		if child.update then
			child:update(dt)
		end
	end
end

function Container:getDimensions()
	return self.w, self.h
end

function Container:getPosition()
	return self.x, self.y
end

function Container:draw()
	if self.backgroundColor then
		love.graphics.setColor(self.backgroundColor)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end

	if self.border or self.borderColor then
		love.graphics.setColor(self.borderColor)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end


	if self.scrollable then
		love.graphics.setScissor(self.x, self.y, self.w, self.h)
		love.graphics.push()
		love.graphics.translate(0, -self.scrollY)
	end

	for _, child in ipairs(self.children) do
		child:draw()
	end

	if self.scrollable then
		love.graphics.pop()
		love.graphics.setScissor()
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Container
