local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "annotations")
local Button = require(folder_path .. "button")
local Image = require(folder_path .. "image")
local Bar = require(folder_path .. "bar")
local Track = require(folder_path .. "track")
local Text = require(folder_path .. "text")
local DropDown = require(folder_path .. "dropdown")
local Form = require(folder_path .. "form")
local Slider = require(folder_path .. "slider")
local activeDropDown

local Container = {}
Container.__index = Container

---@param settings Glorp.containerSettings
---@return Glorp.Container
function Container.new(settings)
	local instance = setmetatable({}, Container)
	instance.id = settings.id
	instance.type = "container"
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

	if settings.scrollable and not settings.scrollDirection then
		if settings.layout == "vertical" then
			settings.scrollDirection = "vertical"
		else
			settings.scrollDirection = "horizontal"
		end
	end

	instance.bar = Bar.new(settings)
	instance.track = Track.new(settings)

	instance.children = {}
	return instance
end

function Container:addContainer(container)
	container.parent = self
	table.insert(self.children, container)
end

---@param settings Glorp.ButtonSettings
---@return Glorp.Container
function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	return self
end

---@param settings Glorp.TextSettings
---@return Glorp.Container
function Container:addText(settings)
	local w = settings.w or self.w
	settings.w = w
	local text = Text.new(settings)
	table.insert(self.children, text)
	return self
end

---@param settings Glorp.DropDownSettings
---@return Glorp.Container
function Container:addDropDown(settings)
	local dropdown = DropDown.new(settings)
	table.insert(self.children, dropdown)
	return self
end

function Container:addForm(settings)
	local form = Form.new(settings)
	table.insert(self.children, form)
	return self
end

-- function Container:addButtonList(settings)
-- 	for i, label in ipairs(settings.list) do
-- 		local fn = function()
-- 			settings.target[settings.property] = i
-- 		end

-- 		local button = Button.new({
-- 			label = tostring(label),
-- 			w = settings.w,
-- 			h = settings.h,
-- 			fn = fn
-- 		})

-- 		table.insert(self.children, button)
-- 	end

-- 	return self
-- end

---@param settings Glorp.ImageSettings
---@return Glorp.Container
function Container:addImage(settings)
	local image = Image.new(settings)
	table.insert(self.children, image)
	return self
end

---@param settings Glorp.SliderSettings
---@return Glorp.Container
function Container:addSlider(settings)
	local slider = Slider.new(settings)
	table.insert(self.children, slider)
	return self
end

function Container:positionChildren()
	local childrenTotalWidth, childrenTotalHeight = self:calculateContentWidth(), self:calculateContentHeight()

	local startX, startY
	if self.alignment.horizontal == "center" and self.scrollDirection ~= "horizontal" then
		startX = self.x + (self.w - childrenTotalWidth) / 2
	elseif self.alignment.horizontal == "right" and self.scrollDirection ~= "horizontal" then
		startX = self.x + self.w - childrenTotalWidth
	else
		startX = self.x
	end

	if self.alignment.vertical == "center" and self.scrollDirection ~= "vertical" then
		startY = self.y + (self.h - childrenTotalHeight) / 2
	elseif self.alignment.vertical == "bottom" and self.scrollDirection ~= "vertical" then
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
			child.y = offsetY
			if self.alignment.vertical == "bottom" then
				child.y = self.y + self.h - child.h
			elseif self.alignment.vertical == "center" then
				child.y = self.y + (self.h - child.h) / 2
			else
				child.y = self.y
			end
			offsetX = offsetX + child.w + self.spacing
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

		if child.type == "slider" then
			child:setPosition(child.x, child.y)
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
	-- if not self:isMouseInside(mx, my, self) then return end

	if activeDropDown then
		activeDropDown:mousepressed(mx, my, button, isTouch)
		activeDropDown = nil
		return
	end

	for _, child in ipairs(self.children) do
		if child.mousepressed then
			local handled = child:mousepressed(mx, my, button, isTouch)
			if handled then
				if child.type == "dropdown" then
					activeDropDown = child
				end
				return true
			end
		end
	end

	if not self.scrollable then return end

	-- Vertical scrollbar
	if self.scrollDirection == "vertical" and self.maxScrollY > 0 then
		local barX = self.x + self.w - self.bar.w
		if mx >= barX and mx <= barX + self.bar.w and my >= self.bar.y and my <= self.bar.y + self.bar.h then
			self.draggingBar = true
			self.barOffsetY = my - self.bar.y
			return
		end
	end

	-- Horizontal scrollbar
	if self.scrollDirection == "horizontal" and self.maxScrollX > 0 then
		local barY = self.y + self.h - self.bar.h
		if my >= barY and my <= barY + self.bar.h and mx >= self.bar.x and mx <= self.bar.x + self.bar.w then
			self.draggingBar = true
			self.barOffsetX = mx - self.bar.x
			return
		end
	end
end

function Container:mousereleased(mx, my, button, isTouch)
	for _, child in ipairs(self.children) do
		if child.mousereleased then
			child:mousereleased(mx, my, button, isTouch)
		end
	end
	self.draggingBar = false
end

function Container:mousemoved(x, y, dx, dy, istouch)
	for _, child in ipairs(self.children) do
		if child.mousemoved then
			child:mousemoved(x, y, dx, dy, istouch)
		end
	end

	if self.draggingBar and self.scrollable then
		if self.scrollDirection == "vertical" then
			local trackHeight = self.h - self.bar.h
			local newBarY = math.max(self.y, math.min(y - self.barOffsetY, self.y + trackHeight))
			self.bar.y = newBarY
			self.scrollY = ((self.bar.y - self.y) / trackHeight) * self.maxScrollY
		elseif self.scrollDirection == "horizontal" then
			local trackWidth = self.w - self.bar.w
			local newBarX = math.max(self.x, math.min(x - self.barOffsetX, self.x + trackWidth))
			self.bar.x = newBarX
			self.scrollX = ((self.bar.x - self.x) / trackWidth) * self.maxScrollX
		end
	end
end

function Container:keypressed(key, scancode, isrepeat)
	for _, child in ipairs(self.children) do
		if child.keypressed then
			child:keypressed(key, scancode, isrepeat)
		end
	end
end

function Container:textinput(text)
	for _, child in ipairs(self.children) do
		if child.textinput then
			child:textinput(text)
		end
	end
end

function Container:update(dt)
	if #self.children == 0 then return end

	for _, child in ipairs(self.children) do
		if child.update then
			child:update(dt)
		end
	end

	self.w = (self.scrollable and self.w) or math.max(self.w, self:calculateContentWidth())
	self.h = (self.scrollable and self.h) or math.max(self.h, self:calculateContentHeight())

	self:positionChildren()

	if self.scrollable then
		if self.scrollDirection == "vertical" then
			local contentHeight = 0
			local spacingCount = 0

			if self.layout == "vertical" then
				for _, child in ipairs(self.children) do
					local h = (child.calculateContentHeight and not child.scrollable) and child:calculateContentHeight() or
						child.h
					contentHeight = contentHeight + h
					spacingCount = spacingCount + 1
				end
				contentHeight = contentHeight + self.spacing * math.max(0, spacingCount - 1)
			else -- layout is horizontal but vertical scrolling
				for _, child in ipairs(self.children) do
					local h = (child.calculateContentHeight and not child.scrollable) and child:calculateContentHeight() or
						child.h
					contentHeight = math.max(contentHeight, h)
				end
			end

			self.maxScrollY = math.max(0, contentHeight - self.h)
		elseif self.scrollDirection == "horizontal" then
			local contentWidth = 0
			local spacingCount = 0

			if self.layout == "horizontal" then
				for _, child in ipairs(self.children) do
					local w = (child.calculateContentWidth and not child.scrollable) and child:calculateContentWidth() or
						child.w
					contentWidth = contentWidth + w
					spacingCount = spacingCount + 1
				end
				contentWidth = contentWidth + self.spacing * math.max(0, spacingCount - 1)
			else -- layout is vertical but horizontal scrolling
				for _, child in ipairs(self.children) do
					local w = (child.calculateContentWidth and not child.scrollable) and child:calculateContentWidth() or
						child.w
					contentWidth = math.max(contentWidth, w)
				end
			end

			self.maxScrollX = math.max(0, contentWidth - self.w)
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

	-- Draw vertical scrollbar
	if self.scrollDirection == "vertical" and self.maxScrollY > 0 then
		local trackX = self.x + self.w - self.bar.w
		local trackY = self.y
		self.track:draw(trackX, trackY, self.bar.w, self.h)

		-- Draw thumb
		self.bar.y = self.y + (self.scrollY / self.maxScrollY) * (self.h - self.bar.h)
		self.bar:draw(trackX, self.bar.y)

		-- Draw horizontal scrollbar
	elseif self.scrollDirection == "horizontal" and self.maxScrollX > 0 then
		local trackX = self.x
		local trackY = self.y + self.h - self.bar.h
		self.track:draw(trackX, trackY, self.w, self.bar.h)

		-- Draw thumb
		self.bar.x = self.x + (self.scrollX / self.maxScrollX) * (self.w - self.bar.w)
		self.bar:draw(self.bar.x, trackY)
	end

	if self.border or self.borderColor then
		love.graphics.setColor(self.borderColor)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end

	love.graphics.push("all")

	local sx, sy = love.graphics.transformPoint(self.x, self.y)

	if not DEBUG then
		if love.graphics.getScissor() then
			love.graphics.intersectScissor(sx, sy, self.w, self.h)
		else
			love.graphics.setScissor(sx, sy, self.w, self.h)
		end
	end

	for _, child in ipairs(self.children) do
		child:draw()
	end

	love.graphics.pop()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if activeDropDown then
		activeDropDown:draw()
		love.graphics.print("activeDropDown")
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Container
