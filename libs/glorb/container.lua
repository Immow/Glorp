-- Updated Glorb Container with recursive dimension calculation, chaining, auto-layout, alignment, image support, and scrollbar/scrolling logic

local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "annotations")
local Button = require(folder_path .. "button")
local Image = require(folder_path .. "image")

local Container = {}
Container.__index = Container

function Container.new(settings)
	local self = setmetatable({}, Container)

	self.id = settings.id
	self.x = settings.x or 0
	self.y = settings.y or 0
	self.w = settings.w or 0
	self.h = settings.h or 0
	self.layout = settings.layout or "vertical"
	self.spacing = settings.spacing or 10
	self.label = "container"
	self.children = {}
	self.parent = nil
	self.alignment = settings.alignment or { horizontal = "left", vertical = "top" }

	self.border = settings.border ~= false
	self.borderColor = settings.borderColor or { 0, 0, 0, 1 }
	self.backgroundColor = settings.backgroundColor or { 0, 0, 0, 1 }
	self.scrollable = settings.scrollable or false
	self.showScrollbar = settings.showScrollbar or false
	self.scrollY = 0
	self.maxScrollY = 0
	self.draggingBar = false
	self.barOffsetY = 0
	self.bar = {
		x = 0,
		y = 0,
		w = (settings.bar and settings.bar.w) or 5,
		h = (settings.bar and settings.bar.h) or 20,
		color = (settings.bar and settings.bar.color) or { 0.8, 0.8, 0.8, 0.7 }
	}

	if settings.scrollable then
		self.alignment.vertical = "top"
	end

	return self
end

function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	self:getDimensions()
	return self
end

function Container:addImage(settings)
	local image = Image.new(settings)
	table.insert(self.children, image)
	self:getDimensions()
	return self
end

function Container:addContainer(settings)
	local container = Container.new(settings)
	container.parent = self
	table.insert(self.children, container)
	self:getDimensions()
	return container
end

function Container:addButtonList(settings)
	for i, label in ipairs(settings.list) do
		local fn = function()
			settings.target[settings.property] = i
			if settings.onClick then settings.onClick(i, label) end
		end

		local button = Button.new({
			label = tostring(label),
			w = settings.w,
			h = settings.h,
			fn = fn
		})

		table.insert(self.children, button)
	end

	self:getDimensions()
	return self
end

function Container:done()
	return self.parent or self
end

function Container:getDimensions()
	local totalW, totalH = -self.spacing, -self.spacing
	local maxW, maxH = 0, 0

	for _, child in ipairs(self.children) do
		local w, h = 0, 0
		if child.getDimensions then
			w, h = child:getDimensions()
		elseif child.w and child.h then
			w, h = child.w, child.h
		end

		if self.layout == "horizontal" then
			totalW = totalW + w + self.spacing
			maxH = math.max(maxH, h)
		else
			totalH = totalH + h + self.spacing
			maxW = math.max(maxW, w)
		end
	end

	if self.layout == "horizontal" then
		self.w = math.max(self.w, totalW)
		if not self.scrollable then
			self.h = math.max(self.h, maxH)
		end
	else
		self.w = math.max(self.w, maxW)
		if not self.scrollable then
			self.h = math.max(self.h, totalH)
		end
	end

	self.maxScrollY = math.max(0, totalH - self.h)

	-- Positioning
	local offsetX, offsetY = self.x, self.y
	if self.alignment.vertical == "center" then
		offsetY = self.y + (self.h - totalH) / 2
	elseif self.alignment.vertical == "bottom" then
		offsetY = self.y + (self.h - totalH)
	end

	if self.alignment.horizontal == "center" then
		offsetX = self.x + (self.w - totalW) / 2
	elseif self.alignment.horizontal == "right" then
		offsetX = self.x + (self.w - totalW)
	end

	for _, child in ipairs(self.children) do
		local w, h = child.getDimensions and child:getDimensions() or child.w or 0, child.h or 0

		if self.layout == "horizontal" then
			child.x = offsetX
			child.y = (self.alignment.vertical == "center") and (self.y + (self.h - h) / 2)
				or (self.alignment.vertical == "bottom") and (self.y + self.h - h)
				or self.y
			offsetX = offsetX + w + self.spacing
		else
			child.x = (self.alignment.horizontal == "center") and (self.x + (self.w - w) / 2)
				or (self.alignment.horizontal == "right") and (self.x + self.w - w)
				or self.x
			child.y = offsetY
			offsetY = offsetY + h + self.spacing
		end
	end

	return self.w, self.h
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
		if mx >= barX and mx <= barX + self.bar.w and my >= self.bar.y and my <= self.bar.h + self.bar.y then
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

function Container:mousereleased()
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
		if child.draw then
			child:draw()
		end
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
