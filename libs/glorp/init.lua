local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "glorp.annotations")

local Glorp = {
	elements = {}
}

Glorp.Container = require(folder_path .. "glorp.container")

function Glorp.registerElement(element)
	if element.id then
		Glorp.elements[element.id] = element
	else
		error("no id specified in the arguments")
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
	Glorp.registerElement(instance)
	return instance
end

function Glorp:wheelmoved(x, y)
	for _, element in pairs(self.elements) do
		if element.wheelmoved and not element.parent and element.enabled then
			element:wheelmoved(x, y)
		end
	end
end

function Glorp:mousemoved(x, y, dx, dy)
	for _, element in pairs(self.elements) do
		if element.mousemoved and not element.parent and element.enabled then
			element:mousemoved(x, y, dx, dy)
		end
	end
end

function Glorp:mousereleased(x, y, button, isTouch)
	for _, element in pairs(self.elements) do
		if element.mousereleased and not element.parent and element.enabled then
			element:mousereleased(x, y, button, isTouch)
		end
	end
end

function Glorp:mousepressed(x, y, button, isTouch)
	local topmost = nil

	for _, element in pairs(self.elements) do
		if element.mousepressed and not element.parent and element.enabled then
			topmost = element
		end
	end

	if topmost then
		topmost:mousepressed(x, y, button, isTouch)
	end
end

function Glorp:textinput(text)
	for _, element in pairs(self.elements) do
		if element.textinput and not element.parent and element.enabled then
			element:textinput(text)
		end
	end
end

function Glorp:keypressed(key, scancode, isrepeat)
	for _, element in pairs(self.elements) do
		if element.keypressed and not element.parent and element.enabled then
			element:keypressed(key, scancode, isrepeat)
		end
	end
end

function Glorp:update(dt)
	for _, element in pairs(self.elements) do
		if element.update and not element.parent and element.enabled then
			element:update(dt)
		end
	end
end

function Glorp:draw()
	for _, element in pairs(self.elements) do
		if element.draw and not element.parent and element.enabled then
			element:draw()
		end
	end
end

return Glorp
