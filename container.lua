local Button = require("button")
local Container = {}
Container.__index = Container

function Container.new(settings)
	local instance    = setmetatable({}, Container)
	instance.x        = settings.x or 0
	instance.y        = settings.y or 0
	instance.w        = settings.w or 0
	instance.h        = settings.h or 0
	instance.layout   = settings.layout or "horizontal"
	instance.spacing  = settings.spacing or 10
	instance.label    = "container"
	instance.children = {}
	return instance
end

function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	self:updateChildren()
	return self
end

function Container:addContainer(settings)
	local container = Container.new(settings)
	table.insert(self.children, container)
	self:updateChildren()
	return self
end

function Container:attach(targets, side)
	if targets.label then
		targets = { targets }
	end

	for i = 1, #targets do
		if side == "bottom" then
			self.x = targets[1].x
			self.y = targets[1].y + targets[1].h
			self.w = self.w + targets[i].w
		elseif side == "right" then
			self.x = targets[1].x + targets[1].w
			self.y = targets[1].y
			self.h = self.h + targets[i].h
		end
	end
	return self
end

function Container:updateChildren()
	local offset = 0
	local maxWidth, maxHeight = 0, 0

	for _, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			child.x = self.x + offset
			child.y = self.y
			offset = offset + child.w + self.spacing
			maxHeight = math.max(maxHeight, child.h)
		else
			child.x = self.x
			child.y = self.y + offset
			offset = offset + child.h + self.spacing
			maxWidth = math.max(maxWidth, child.w)
		end
	end

	if self.layout == "horizontal" then
		self.w = math.max(offset - self.spacing, self.w)
		self.h = math.max(maxHeight, self.h)
	else
		self.w = math.max(maxWidth, self.w)
		self.h = math.max(offset - self.spacing, self.h)
	end
end

function Container:update(dt)

end

function Container:getDimensions()
	return self.w, self.h
end

function Container:getPosition()
	return self.x, self.y
end

function Container:draw()
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(1, 1, 1, 1)
	for _, child in ipairs(self.children) do
		child:draw()
	end
end

return Container
