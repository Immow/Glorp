local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "annotations")
local Button = require(folder_path .. "button")
local Image = require(folder_path .. "image")

local Container = {}
Container.__index = Container

---@param settings Glorb.containerSettings
---@return Glorb.Container
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
	instance.border = settings.border ~= false
	instance.borderColor = settings.borderColor or { 0, 0, 0, 1 }
	instance.backgroundColor = settings.backgroundColor or { 0, 0, 0, 1 }
	instance.scrollable = settings.scrollable or false
	instance.showScrollbar = settings.showScrollbar or false
	instance.scrollDirection = settings.scrollDirection or "vertical"
	instance.scrollY = 0
	instance.maxScrollY = 0
	instance.scrollX = 0
	instance.maxScrollX = 0
	instance.draggingBar = false
	instance.barOffsetY = 0
	instance.alignment = {
		horizontal = (settings.alignment and settings.alignment.horizontal) or "center",
		vertical = (settings.alignment and settings.alignment.vertical) or "center"
	}
	instance.bar = {
		x = 0,
		y = 0,
		w = (settings.bar and settings.bar.w) or 5,
		h = (settings.bar and settings.bar.h) or 20,
		color = (settings.bar and settings.bar.color) or { 0.8, 0.8, 0.8, 0.7 }
	}

	if settings.scrollable then
		instance.alignment.vertical = "top"
	end

	instance.children = {}

	return instance
end

---@param settings Glorb.ButtonSettings
---@return Glorb.Container
function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	self:updateChildren()
	return self
end

function Container:addButtonList(settings)
	for i, label in ipairs(settings.list) do
		local fn = function()
			settings.target[settings.property] = i
		end

		local button = Button.new({
			label = tostring(label),
			w = settings.w,
			h = settings.h,
			fn = fn
		})

		table.insert(self.children, button)
	end

	self:updateChildren()
	return self
end

---@param settings Glorb.ImageSettings
---@return Glorb.Container
function Container:addImage(settings)
	local image = Image.new(settings)
	table.insert(self.children, image)
	self:updateChildren()
	return self
end

function Container:updateChildren()
	local childrenTotalWidth, childrenTotalHeight = 0, 0
	local maxScrollHeight, maxScrollXWidth = 0, 0


	if self.layout == "horizontal" then
		childrenTotalWidth = -self.spacing
		for _, child in ipairs(self.children) do
			childrenTotalWidth = childrenTotalWidth + child.w + self.spacing
			childrenTotalHeight = math.max(childrenTotalHeight, child.h)
			maxScrollHeight = maxScrollHeight + child.h + self.spacing
			maxScrollXWidth = maxScrollXWidth + child.w + self.spacing
		end
	else
		childrenTotalHeight = -self.spacing
		for _, child in ipairs(self.children) do
			childrenTotalHeight = childrenTotalHeight + child.h + self.spacing
			childrenTotalWidth = math.max(childrenTotalWidth, child.w)
			maxScrollHeight = maxScrollHeight + child.h + self.spacing
			maxScrollXWidth = maxScrollXWidth + child.w + self.spacing
		end
	end

	if not self.scrollable then
		self.w = math.max(self.w, childrenTotalWidth)
		self.h = math.max(self.h, childrenTotalHeight)
	elseif self.scrollable and self.scrollDirection == "vertical" then
		self.maxScrollY = maxScrollHeight - (self.h + self.spacing)
		self.w = math.max(self.w, childrenTotalWidth)
	elseif self.scrollable and self.scrollDirection == "horizontal" then
		self.maxScrollX = maxScrollXWidth - (self.w + self.spacing)
		self.h = math.max(self.h, childrenTotalHeight)
	end

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
			if self.alignment.horizontal == "right" then
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

	if self.showScrollbar and self.scrollable and self.maxScrollY > 0 then
		local barX = self.x + self.w - self.bar.w
		if mx >= barX and mx <= barX + self.bar.w and my >= self.bar.y and my <= self.bar.y + self.bar.h then
			self.draggingBar = true
			self.barOffsetY = my - self.bar.y
			return
		end
	end

	local adjustedY = my + (self.scrollable and self.scrollY or 0)
	for _, child in ipairs(self.children) do
		if child.mousepressed then
			child:mousepressed(mx, adjustedY, button, isTouch)
		end
	end
end

function Container:mousereleased(mx, my, button, isTouch)
	self.draggingBar = false
end

function Container:mousemoved(x, y, dx, dy, istouch)
	if self.draggingBar and self.scrollable then
		local trackHeight = self.h - self.bar.h
		local newBarY = math.max(self.y, math.min(y - self.barOffsetY, self.y + trackHeight))
		self.bar.y = newBarY
		self.scrollY = ((self.bar.y - self.y) / trackHeight) * self.maxScrollY
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

	if self.showScrollbar and self.scrollable and self.maxScrollY > 0 then
		self.bar.y = self.y + (self.scrollY / self.maxScrollY) * (self.h - self.bar.h)
		love.graphics.setColor(self.bar.color)
		love.graphics.rectangle("fill", self.x + self.w - self.bar.w, self.bar.y, self.bar.w, self.bar.h)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Container
