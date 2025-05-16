local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "glorp.annotations")

local Glorp = {
	elements = {},
	elementsById = {},
	activeDropDown = nil,
	activeWindow = nil
}

Glorp.Container = require(folder_path .. "glorp.container")

function Glorp.registerElement(id, element)
	if not id then error("no id specified in the arguments") end
	if Glorp.elementsById[id] then
		error("Duplicate element ID: " .. id)
	end
	Glorp.elementsById[id] = element
	table.insert(Glorp.elements, element) -- sequential array for input/draw order
end

function Glorp:getElementById(id)
	-- Check if it's a registered container
	if self.elementsById[id] then
		return self.elementsById[id]
	end

	-- Search children of all top-level containers
	for _, container in pairs(self.elementsById) do
		if container.getChildById then
			local found = container:getChildById(id)
			if found then return found end
		end
	end

	return nil -- Not found
end

function Glorp:bringToFront(element)
	for i, el in ipairs(self.elements) do
		if el == element then
			table.remove(self.elements, i)
			table.insert(self.elements, el)
			self.activeWindow = el
			break
		end
	end
end

function Glorp:purge()
	self.elements = {}
end

function Glorp:setEnabled(container, value)
	container.enabled = value
end

function Glorp.attach(element_id, target_ids, side)
	local element = Glorp.elements[element_id]
	if not element then
		error("Element with ID " .. element_id .. " not found in Glorp.")
	end

	if type(target_ids) == "string" then
		target_ids = { target_ids }
	end

	local targets = {}
	for _, id in ipairs(target_ids) do
		local target = Glorp.elements[id]
		if not target then
			error("Target element with ID " .. id .. " not found.")
		end
		table.insert(targets, target)
	end

	local anchor = targets[1]
	local totalWidth, totalHeight = 0, 0
	for _, target in ipairs(targets) do
		totalWidth = totalWidth + target.w
		totalHeight = totalHeight + target.h
	end

	if side == "bottom" then
		element.x = anchor.x
		element.y = anchor.y + anchor.h
		element.w = totalWidth
	elseif side == "top" then
		element.x = anchor.x
		element.y = anchor.y - element.h
		element.w = totalWidth
	elseif side == "right" then
		element.x = anchor.x + anchor.w
		element.y = anchor.y
		element.h = totalHeight
	elseif side == "left" then
		element.x = anchor.x - element.w
		element.y = anchor.y
		element.h = totalHeight
	end

	if element.updateChildren then
		element:updateChildren()
	end

	return element
end

---@param settings Glorp.containerSettings
---@return Glorp.Container
function Glorp.newContainer(settings)
	local instance = Glorp.Container.new(settings)
	Glorp.registerElement(instance.id, instance)
	return instance
end

function Glorp:wheelmoved(x, y)
	if self.activeWindow and self.activeWindow.wheelmoved then
		self.activeWindow:wheelmoved(x, y)
	end
end

function Glorp:mousemoved(x, y, dx, dy)
	if self.activeWindow and self.activeWindow.mousemoved then
		self.activeWindow:mousemoved(x, y, dx, dy)
	end
end

function Glorp:mousereleased(x, y, button, isTouch)
	if self.activeWindow and self.activeWindow.mousereleased then
		self.activeWindow:mousereleased(x, y, button, isTouch)

		if not self.activeWindow:isMouseInside(x, y) then
			self.activeWindow = nil
		end
	end
end

function Glorp:mousepressed(x, y, button, isTouch)
	if self.activeDropDown and self.activeDropDown.expanded then
		if self.activeDropDown.mousepressed then
			self.activeDropDown:mousepressed(x, y, button, isTouch)
		end
		self.activeDropDown.expanded = false
		self.activeDropDown = nil
		return
	end

	for i = #self.elements, 1, -1 do
		local element = self.elements[i]
		if element.mousepressed and not element.parent and element.enabled then
			if element:mousepressed(x, y, button, isTouch) then
				self:bringToFront(element)
				break
			end
		end
	end
end

function Glorp:textinput(t)
	if self.activeWindow and self.activeWindow.textinput then
		self.activeWindow:textinput(t)
	end
end

function Glorp:keypressed(key, scancode, isrepeat)
	if self.activeWindow and self.activeWindow.keypressed then
		self.activeWindow:keypressed(key, scancode, isrepeat)
	end
end

function Glorp:update(dt)
	for _, element in ipairs(self.elements) do
		if element.update and not element.parent and element.enabled then
			element:update(dt)
		end
	end
end

function Glorp:draw()
	for _, element in ipairs(self.elements) do
		if element.draw and not element.parent and element.enabled then
			element:draw()
		end
	end

	-- Draw dropdown last so it appears on top of everything
	if self.activeDropDown and self.activeDropDown.draw then
		self.activeDropDown:draw()
	end
end

return Glorp
