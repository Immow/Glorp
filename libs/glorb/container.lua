-- Updated Glorb Container with recursive dimension calculation, chaining, auto-layout, alignment, and image support

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

	self.w = (self.layout == "horizontal") and math.max(0, totalW) or maxW
	self.h = (self.layout == "horizontal") and maxH or math.max(0, totalH)

	-- Position children with alignment
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
			if self.alignment.vertical == "center" then
				child.y = self.y + (self.h - h) / 2
			elseif self.alignment.vertical == "bottom" then
				child.y = self.y + (self.h - h)
			else
				child.y = self.y
			end
			offsetX = offsetX + w + self.spacing
		else
			child.y = offsetY
			if self.alignment.horizontal == "center" then
				child.x = self.x + (self.w - w) / 2
			elseif self.alignment.horizontal == "right" then
				child.x = self.x + (self.w - w)
			else
				child.x = self.x
			end
			offsetY = offsetY + h + self.spacing
		end
	end

	return self.w, self.h
end

function Container:draw()
	love.graphics.setColor(1, 0, 0, 0.5)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(1, 1, 1, 1)

	for _, child in ipairs(self.children) do
		if child.draw then
			child:draw()
		end
	end
end

return Container
