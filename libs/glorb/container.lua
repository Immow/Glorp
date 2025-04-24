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

	return self
end

function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	return self
end

function Container:addImage(settings)
	local image = Image.new(settings)
	table.insert(self.children, image)
	return self
end

function Container:addContainer(settings)
	local container = Container.new(settings)
	container.parent = self
	table.insert(self.children, container)
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
