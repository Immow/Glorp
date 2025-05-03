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
		w = (settings.bar and settings.bar.w) or 20,
		h = (settings.bar and settings.bar.h) or 50,
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
	return self
end

function Container:addContainer(container)
	container.parent = self
	table.insert(self.children, container)
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

	return self
end

---@param settings Glorb.ImageSettings
---@return Glorb.Container
function Container:addImage(settings)
	local image = Image.new(settings)
	table.insert(self.children, image)
	return self
end

function Container:positionChildren()
	local childrenTotalWidth, childrenTotalHeight = self:calculateContentWidth(), self:calculateContentHeight()

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

	if self.scrollable then
		if self.scrollDirection == "vertical" then
			startY = startY - self.scrollY
		elseif self.scrollDirection == "horizontal" then
			startX = startX - self.scrollX
		end
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
				child.y = self.y
			end
			offsetX = offsetX + child.w + self.spacing
			child.y = offsetY
		else
			child.x = offsetX
			child.y = offsetY
			if self.alignment.horizontal == "right" then
				child.x = self.x + self.w - child.w
			elseif self.alignment.horizontal == "center" then
				child.x = self.x + (self.w - child.w) / 2
			else
				child.x = self.x
			end
			offsetY = offsetY + child.h + self.spacing
		end
	end
end

function Container:calculateContentWidth()
	if #self.children == 0 then return 0 end

	if self.layout == "horizontal" then
		local totalWidth = 0
		for i, child in ipairs(self.children) do
			totalWidth = totalWidth + child.w
		end
		totalWidth = totalWidth + self.spacing * (#self.children - 1)
		return totalWidth
	else
		local maxWidth = 0
		for _, child in ipairs(self.children) do
			maxWidth = math.max(maxWidth, child.w)
		end
		return maxWidth
	end
end

function Container:calculateContentHeight()
	if #self.children == 0 then return 0 end

	if self.layout == "horizontal" then
		local maxHeight = 0
		for _, child in ipairs(self.children) do
			maxHeight = math.max(maxHeight, child.h)
		end
		return maxHeight
	else
		local totalHeight = 0
		for _, child in ipairs(self.children) do
			totalHeight = totalHeight + child.h
		end
		totalHeight = totalHeight + self.spacing * (#self.children - 1)
		return totalHeight
	end
end

function Container:calculateScrollSize()
	if #self.children == 0 then return 0 end

	local totalSize = 0

	if self.scrollDirection == "horizontal" then
		for _, child in ipairs(self.children) do
			totalSize = totalSize + child.w
		end
	else
		for _, child in ipairs(self.children) do
			totalSize = totalSize + child.h
		end
	end

	totalSize = totalSize + self.spacing * (#self.children - 1)
	return totalSize
end

function Container:wheelmoved(x, y)
	local mx, my = love.mouse.getPosition()

	local scrolled = false
	for _, child in ipairs(self.children) do
		if child.wheelmoved then
			scrolled = child:wheelmoved(x, y) or scrolled
		end
	end

	if scrolled then return true end

	if self.scrollable and self:isMouseInside(mx, my, self) then
		self.scrollY = math.max(0, math.min(self.scrollY - y * 20, self.maxScrollY))
		return true --previousScrollY ~= self.scrollY -- Allow scrolling if we can't scroll anymore in this element
	end

	return scrolled
end

function Container:isMouseInside(mx, my, target)
	return mx >= target.x and mx <= target.x + target.w
		and my >= target.y and my <= target.y + target.h
end

function Container:mousepressed(mx, my, button, isTouch)
	-- Optional: only trigger if mouse is inside this container
	if not self:isMouseInside(mx, my, self) then return end

	for _, child in ipairs(self.children) do
		if child.mousepressed then
			child:mousepressed(mx, my, button, isTouch)
		end
	end

	if self.showScrollbar and self.scrollable and self.maxScrollY > 0 then
		local barX = self.x + self.w - self.bar.w
		if mx >= barX and mx <= barX + self.bar.w and my >= self.bar.y and my <= self.bar.y + self.bar.h then
			self.draggingBar = true
			self.barOffsetY = my - self.bar.y
			return
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
	if #self.children == 0 then return end

	for _, child in ipairs(self.children) do
		if child.update then
			child:update(dt)
		end
	end

	self.w = (self.scrollable and self.w) or self:calculateContentWidth()
	self.h = (self.scrollable and self.h) or self:calculateContentHeight()

	self:positionChildren()

	if self.scrollable and self.scrollDirection == "vertical" then
		local contentHeight = 0
		local spacingCount = 0

		if self.layout == "vertical" then
			for _, child in ipairs(self.children) do
				local h = 0
				if child.calculateContentHeight and not child.scrollable then
					h = child:calculateContentHeight()
				else
					h = child.h
				end
				contentHeight = contentHeight + h
				spacingCount = spacingCount + 1
			end
			contentHeight = contentHeight + self.spacing * math.max(0, spacingCount - 1)
		else -- layout is horizontal but vertical scrolling
			for _, child in ipairs(self.children) do
				local h = 0
				if child.calculateContentHeight and not child.scrollable then
					h = child:calculateContentHeight()
				else
					h = child.h
				end
				contentHeight = math.max(contentHeight, h)
			end
		end

		self.maxScrollY = math.max(0, contentHeight - self.h)
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

	love.graphics.push("all")

	local sx, sy = love.graphics.transformPoint(self.x, self.y)

	if love.graphics.getScissor() then
		love.graphics.intersectScissor(sx, sy, self.w, self.h)
	else
		love.graphics.setScissor(sx, sy, self.w, self.h)
	end

	for _, child in ipairs(self.children) do
		child:draw()
	end

	love.graphics.pop()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if self.showScrollbar and self.scrollable and self.maxScrollY > 0 then
		self.bar.y = self.y + (self.scrollY / self.maxScrollY) * (self.h - self.bar.h)
		love.graphics.setColor(self.bar.color)
		love.graphics.rectangle("fill", self.x + self.w - self.bar.w, self.bar.y, self.bar.w, self.bar.h)
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(self.maxScrollY, self.x, self.y)
end

return Container
