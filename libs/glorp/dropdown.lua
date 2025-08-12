local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(settings, Glorp)
	local instance            = setmetatable({}, Dropdown)
	instance.glorpRef         = Glorp
	instance.parent           = parent or nil
	instance.id               = settings.id or nil
	instance.x                = settings.x or 0
	instance.y                = settings.y or 0
	instance.w                = settings.w or 200
	instance.h                = settings.h or 30
	instance.type             = "dropdown"
	instance.options          = settings.options or {}
	instance.selectedIndex    = settings.selectedIndex or 1
	instance.expanded         = false

	instance.onSelect         = settings.onSelect or function(index, value) end

	instance.font             = settings.font or love.graphics:getFont()
	instance.bgColor          = settings.bgColor or { 0.2, 0.2, 0.2, 1 }
	instance.hoverColor       = settings.hoverColor or { 0.3, 0.3, 0.3, 1 }
	instance.expandedBgColor  = settings.hoverColor or { 0.1, 0.1, 0.1, 1 }
	instance.hoverOptionColor = settings.hoverOptionColor or { 0.2, 0.6, 1, 1 }
	instance.textColor        = settings.textColor or { 1, 1, 1, 1 }
	instance.enabled          = settings.enabled ~= false

	return instance
end

function Dropdown:update(dt)
	if not self.expanded then
		self.hoveredIndex = nil
		return
	end

	local mx, my = love.mouse.getPosition()
	self.hoveredIndex = nil

	for i, option in ipairs(self.options) do
		local itemY = self.y + self.h * i
		if mx >= self.x and mx <= self.x + self.w and my >= itemY and my <= itemY + self.h then
			self.hoveredIndex = i
			break
		end
	end
end

function Dropdown:mousepressed(mx, my, mouseButton)
	if mouseButton ~= 1 then return end

	-- If expanded, check if an option was clicked
	if self.expanded then
		for i, option in ipairs(self.options) do
			local itemY = self.y + self.h * i
			if mx >= self.x and mx <= self.x + self.w and my >= itemY and my <= itemY + self.h then
				self.selectedIndex = i
				if self.onSelect then
					self.onSelect(i, option)
				end
				self.expanded = false
				-- self.glorpRef.activeDropDown = nil
				return true
			end
		end
	end

	-- If not on an option, check the main dropdown box
	if self:contains(mx, my) then
		self.expanded = not self.expanded
		self.glorpRef.activeDropDown = self
		return true
	else
		-- Clicked outside
		self.expanded = false
		-- if self.glorpRef.activeDropDown then
		-- 	self.glorpRef.activeDropDown = nil
		-- end
	end

	return false
end

function Dropdown:contains(mx, my)
	return mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h
end

function Dropdown:draw()
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	-- Draw selected item (collapsed view)
	love.graphics.setColor(self.textColor)
	local selected = self.options[self.selectedIndex]
	local fontHeight = self.font:getHeight()
	local selectedTextY = self.y + (self.h - fontHeight) / 2
	love.graphics.printf(selected.name, self.x + 5, selectedTextY, self.w - 10, "left")

	if self.expanded then
		for i, option in ipairs(self.options) do
			local itemY = self.y + self.h * i

			-- Background highlight
			if i == self.hoveredIndex then
				love.graphics.setColor(self.hoverOptionColor)
			else
				love.graphics.setColor(self.expandedBgColor)
			end
			love.graphics.rectangle("fill", self.x, itemY, self.w, self.h)

			-- Text centered vertically in each item
			local optionTextY = itemY + (self.h - fontHeight) / 2
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(option.name, self.x + 5, optionTextY, self.w - 10, "left")
		end
	end
end

return Dropdown
