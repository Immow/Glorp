local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(settings)
	local instance            = setmetatable({}, Dropdown)

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
	instance.hoverOptionColor = settings.hoverOptionColor or { 0.2, 0.6, 1, 1 }
	instance.textColor        = settings.textColor or { 1, 1, 1, 1 }

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

	if self:contains(mx, my) then
		self.expanded = not self.expanded
		return true
	else
		if self.expanded then
			for i, option in ipairs(self.options) do
				local itemY = self.y + self.h * i
				if mx >= self.x and mx <= self.x + self.w and my >= itemY and my <= itemY + self.h then
					self.selectedIndex = i
					self.onSelect(i, option)
					self.expanded = false
					return true
				end
			end
		end
		self.expanded = false
	end

	return false
end

function Dropdown:contains(mx, my)
	return mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h
end

function Dropdown:draw()
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(self.textColor)
	local selected = self.options[self.selectedIndex]
	love.graphics.printf(selected.name, self.x + 5, self.y + 5, self.w - 10, "left")

	if self.expanded then
		for i, option in ipairs(self.options) do
			local itemY = self.y + self.h * i

			if i == self.hoveredIndex then
				love.graphics.setColor(self.hoverOptionColor) -- highlight color
				love.graphics.rectangle("fill", self.x, itemY, self.w, self.h)
			end

			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(option.name, self.x + 5, itemY + 5, self.w - 10, "left")
		end
	end
end

return Dropdown
