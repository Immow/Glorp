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
local CheckBox = require(folder_path .. "checkbox")
local RadioButton = require(folder_path .. "radiobutton")
local activeDropDown

local Container = {}
Container.__index = Container

---@param settings Glorp.containerSettings
---@return Glorp.Container
function Container.new(settings)
	local instance = setmetatable({}, Container)
	instance.enabled = settings.enabled ~= false
	instance.childIds = {}
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
	instance.borderColor = settings.borderColor or { 1, 1, 1, 1 }
	instance.backgroundColor = settings.backgroundColor or { 0, 0, 0, 1 }
	instance.scrollable = settings.scrollable or false
	if instance.scrollable and (instance.w <= 0 or instance.h <= 0) then
		error("Scrollable containers must have both width and height greater than 0.")
	end
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

	instance.titlebarHeight = settings.titlebarHeight or 24
	instance.titlebarColor = settings.titlebarColor or { 0.2, 0.2, 0.2, 1 }
	instance.titlebarText = settings.titlebarText or instance.label or instance.id or ""

	instance.titleBar = settings.titleBar or false
	instance.draggable = settings.draggable or false
	instance.dragging = false
	instance.dragOffsetX = 0
	instance.dragOffsetY = 0

	instance.padding = {
		top = settings.paddingTop or settings.padding or 0,
		right = settings.paddingRight or settings.padding or 0,
		bottom = settings.paddingBottom or settings.padding or 0,
		left = settings.paddingLeft or settings.padding or 0,
	}

	instance.bar = Bar.new(settings)
	instance.track = Track.new(settings)

	instance.children = {}
	return instance
end

function Container:addContainer(container)
	container.parent = self
	table.insert(self.children, container)
end

function Container:addChildId(id, reference)
	if not id then return end

	if self.childIds[id] then
		error("Duplicate child ID: " .. id)
	else
		self.childIds[id] = reference
	end
end

---@param settings Glorp.ButtonSettings
---@return Glorp.Container
function Container:addButton(settings)
	local button = Button.new(settings)
	self:addChildId(settings.id, button)
	table.insert(self.children, button)
	return self
end

---@param settings Glorp.TextSettings
---@return Glorp.Container
function Container:addText(settings)
	local w = settings.w or self.w
	settings.w = w
	local text = Text.new(settings)
	self:addChildId(settings.id, text)
	table.insert(self.children, text)
	return self
end

---@param settings Glorp.DropDownSettings
---@return Glorp.Container
function Container:addDropDown(settings)
	local dropdown = DropDown.new(settings, require("libs.glorp"))
	self:addChildId(settings.id, dropdown)
	table.insert(self.children, dropdown)
	return self
end

function Container:addForm(settings)
	local form = Form.new(settings)
	self:addChildId(settings.id, form)
	table.insert(self.children, form)
	return self
end

function Container:addCheckBox(settings)
	local cb = CheckBox.new(settings)
	self:addChildId(settings.id, cb)
	table.insert(self.children, cb)
	return self
end

function Container:addRadioButton(settings)
	local rb = RadioButton.new(settings)
	self:addChildId(settings.id, rb)
	table.insert(self.children, rb)
	return self
end

---@param id string
function Container:getChildById(id)
	for _, child in ipairs(self.children or {}) do
		if child.id == id then
			return child
		end
		-- Recursively search nested containers
		if child.getChildById then
			local found = child:getChildById(id)
			if found then return found end
		end
	end
	return nil
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
	self:addChildId(settings.id, image)
	table.insert(self.children, image)
	return self
end

---@param settings Glorp.SliderSettings
---@return Glorp.Container
function Container:addSlider(settings)
	local slider = Slider.new(settings)
	self:addChildId(settings.id, slider)
	table.insert(self.children, slider)
	return self
end

function Container:getContentOffsetY()
	return self.titleBar and self.titlebarHeight or 0
end

function Container:getBarOffsetX()
	if self.scrollDirection == "vertical" then
		return self.bar and self.bar.w or 0
	end
	return 0
end

function Container:getBarOffsetY()
	if self.scrollDirection == "horizontal" then
		return self.bar and self.bar.h or 0
	end
	return 0
end

function Container:positionChildren()
	local childrenTotalWidth, childrenTotalHeight = self:calculateContentWidth(), self:calculateContentHeight()

	local startX, startY

	if self.alignment.horizontal == "center" and self.scrollDirection ~= "horizontal" then
		startX = self.x + self.padding.left + (self.w - self.padding.left - self.padding.right - childrenTotalWidth) / 2
	elseif self.alignment.horizontal == "right" and self.scrollDirection ~= "horizontal" then
		startX = self.x + self.w - self.padding.right - childrenTotalWidth - self:getBarOffsetX()
	else
		startX = self.x + self.padding.left
	end

	if self.alignment.vertical == "center" and self.scrollDirection ~= "vertical" then
		startY = self.y + self.padding.top + (self.h - self.padding.top - self.padding.bottom - childrenTotalHeight) / 2
	elseif self.alignment.vertical == "bottom" and self.scrollDirection ~= "vertical" then
		startY = self.y + self.h - self.padding.bottom - childrenTotalHeight - self:getBarOffsetY()
	else
		startY = self.y + self.padding.top
	end

	if self.scrollable then
		if self.scrollDirection == "vertical" then
			startY = startY - self.scrollY
		elseif self.scrollDirection == "horizontal" then
			startX = startX - self.scrollX
		end
	end

	local offsetX, offsetY = startX, startY + self:getContentOffsetY()
	for _, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			child.x = offsetX
			child.y = offsetY

			if self.alignment.vertical == "bottom" then
				child.y = self.y + self.h - self.padding.bottom - child.h - self:getBarOffsetY()
			elseif self.alignment.vertical == "center" then
				child.y = self.y + self.padding.top + (self.h - self.padding.top - self.padding.bottom - child.h) / 2
			else
				child.y = self.y + self.padding.top + self:getContentOffsetY()
			end

			offsetX = offsetX + child.w + self.spacing
			child.y = offsetY
		else
			child.x = offsetX
			child.y = offsetY

			if self.alignment.horizontal == "right" then
				child.x = self.x + self.w - self.padding.right - child.w - self:getBarOffsetX()
			elseif self.alignment.horizontal == "center" then
				child.x = self.x + self.padding.left + (self.w - self.padding.left - self.padding.right - child.w) / 2
			else
				child.x = self.x + self.padding.left
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

		return maxHeight + self:getContentOffsetY()
	else
		local totalHeight = 0
		for _, child in ipairs(self.children) do
			totalHeight = totalHeight + child.h
		end
		totalHeight = totalHeight + self.spacing * (#self.children - 1)

		return totalHeight + self:getContentOffsetY()
	end
end

function Container:wheelmoved(x, y)
	local mx, my = love.mouse.getPosition()

	local scrolled = false
	for _, child in ipairs(self.children) do
		if child.enabled and child.wheelmoved then
			scrolled = child:wheelmoved(x, y) or scrolled
		end
	end

	if scrolled then return true end

	if self.scrollable and self:isMouseInside(mx, my) then
		self.scrollY = math.max(0, math.min(self.scrollY - y * 20, self.maxScrollY))
		return true --previousScrollY ~= self.scrollY -- Allow scrolling if we can't scroll anymore in this element
	end

	return scrolled
end

function Container:isMouseInside(mx, my)
	return mx >= self.x and mx <= self.x + self.w
		and my >= self.y and my <= self.y + self.h
end

function Container:mousepressed(mx, my, button, isTouch)
	-- if not self:isMouseInside(mx, my, self) then return end
	if self.draggable and mx >= self.x and mx <= self.x + self.w
		and my >= self.y and my <= self.y + self.titlebarHeight then
		self.dragging = true
		self.dragOffsetX = mx - self.x
		self.dragOffsetY = my - self.y
		return true
	end

	if activeDropDown and activeDropDown.expanded then
		activeDropDown:mousepressed(mx, my, button, isTouch)
		activeDropDown = nil
		return
	end

	for _, child in ipairs(self.children) do
		if child.enabled and child.mousepressed then
			local handled = child:mousepressed(mx, my, button, isTouch)
			if handled then
				if child.type == "dropdown" then
					activeDropDown = child
				end
				return true
			end
		end
	end

	if self.scrollable then
		-- Vertical scrollbar
		if self.scrollDirection == "vertical" and self.maxScrollY > 0 then
			local barX = self.x + self.w - self.bar.w
			if mx >= barX and mx <= barX + self.bar.w and my >= self.bar.y and my <= self.bar.y + self.bar.h then
				self.draggingBar = true
				self.barOffsetY = my - self.bar.y
				return true
			end
		end

		-- Horizontal scrollbar
		if self.scrollDirection == "horizontal" and self.maxScrollX > 0 then
			local barY = self.y + self.h - self.bar.h
			if my >= barY and my <= barY + self.bar.h and mx >= self.bar.x and mx <= self.bar.x + self.bar.w then
				self.draggingBar = true
				self.barOffsetX = mx - self.bar.x
				return true
			end
		end
	end

	if self:isMouseInside(mx, my) then
		return true
	end
end

function Container:mousereleased(mx, my, button, isTouch)
	for _, child in ipairs(self.children) do
		if child.enabled and child.mousereleased then
			child:mousereleased(mx, my, button, isTouch)
		end
	end
	self.draggingBar = false
	self.dragging = false
end

function Container:mousemoved(x, y, dx, dy, istouch)
	if self.dragging then
		self.x = x - self.dragOffsetX
		self.y = y - self.dragOffsetY

		if #self.children > 0 then
			self:positionChildren()
		end
	end

	for _, child in ipairs(self.children) do
		if child.enabled and child.mousemoved then
			child:mousemoved(x, y, dx, dy, istouch)
		end
	end

	if self.draggingBar and self.scrollable then
		if self.scrollDirection == "vertical" then
			local trackTop = self.y + self:getContentOffsetY()
			local trackHeight = self.h - self:getContentOffsetY() - self.bar.h

			-- Clamp bar.y to stay inside the track
			local newBarY = math.max(trackTop, math.min(y - self.barOffsetY, trackTop + trackHeight))
			self.bar.y = newBarY

			-- Set scrollY proportionally
			local scrollRatio = (self.bar.y - trackTop) / trackHeight
			self.scrollY = scrollRatio * self.maxScrollY
		elseif self.scrollDirection == "horizontal" then
			local trackLeft = self.x
			local trackWidth = self.w - self.bar.w

			-- Clamp bar.x to stay inside the track
			local newBarX = math.max(trackLeft, math.min(x - self.barOffsetX, trackLeft + trackWidth))
			self.bar.x = newBarX

			-- Set scrollX proportionally
			local scrollRatio = (self.bar.x - trackLeft) / trackWidth
			self.scrollX = scrollRatio * self.maxScrollX
		end
	end
end

function Container:keypressed(key, scancode, isrepeat)
	for _, child in ipairs(self.children) do
		if child.enabled and child.keypressed then
			child:keypressed(key, scancode, isrepeat)
		end
	end
end

function Container:textinput(text)
	for _, child in ipairs(self.children) do
		if child.enabled and child.textinput then
			child:textinput(text)
		end
	end
end

function Container:getRequiredHeight()
	return self:calculateContentHeight() + self.padding.top + self.padding.bottom
end

function Container:getRequiredWidth()
	return self:calculateContentWidth() + self.padding.left + self.padding.right
end

function Container:update(dt)
	if #self.children == 0 then return end

	for _, child in ipairs(self.children) do
		if child.enabled and child.update then
			child:update(dt)
		end
	end

	self.w = (self.scrollable and self.w) or math.max(self.w, self:getRequiredWidth())
	self.h = (self.scrollable and self.h) or math.max(self.h, self:getRequiredHeight())

	self:positionChildren()

	-- if self.scrollable and self.scrollDirection == "vertical" and self.maxScrollY > 0 then
	-- 	local trackHeight = self.h - self:getContentOffsetY() - self.bar.h
	-- 	self.bar.y = self.y + self:getContentOffsetY() + (self.scrollY / self.maxScrollY) * trackHeight
	-- end

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
				contentHeight = contentHeight + self.padding.top + self.padding.bottom
			else -- layout is horizontal but vertical scrolling
				for _, child in ipairs(self.children) do
					local h = (child.calculateContentHeight and not child.scrollable) and child:calculateContentHeight() or
						child.h
					contentHeight = math.max(contentHeight, h)
				end
			end

			self.maxScrollY = math.max(0, contentHeight - (self.h - self:getContentOffsetY()))
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
				contentWidth = contentWidth + self.padding.left + self.padding.right
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
		if child.enabled then
			child:draw()
		end
	end

	if self.titleBar and self.titlebarHeight > 0 then
		love.graphics.setColor(self.titlebarColor)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.titlebarHeight)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(self.titlebarText, self.x + 5, self.y + 4)
	end

	if self.border then
		love.graphics.setColor(self.borderColor)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end

	love.graphics.pop()

	love.graphics.setColor(1, 1, 1, 1)
end

return Container
