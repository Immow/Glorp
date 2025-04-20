local folder_path = (...):match("(.-)[^%.]+$")
require(folder_path .. "glorb.annotations")

local Glorb = {
	elements = {}
}

Glorb.Container = require(folder_path .. "glorb.container")

function Glorb.registerElement(element)
	if element.id then
		Glorb.elements[element.id] = element
	else
		error("no id specified in the arguments")
	end
end

function Glorb:purge()
	self.elements = {}
end

function Glorb.attach(element_id, target_ids, side)
	local element = Glorb.elements[element_id]
	if not element then
		error("Element with ID " .. element_id .. " not found in Glorb.")
	end

	if type(target_ids) == "string" then
		target_ids = { target_ids }
	end

	local targets = {}
	for _, id in ipairs(target_ids) do
		local target = Glorb.elements[id]
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

function Glorb.finalizeLayout()
	for _, element in pairs(Glorb.elements) do
		if element.updateChildren then
			element:updateChildren()
		end
	end
end

---@param settings Glorb.containerSettings
function Glorb.newContainer(settings)
	local instance = Glorb.Container.new(settings)
	Glorb.registerElement(instance)
	return instance
end

function Glorb:update(dt)
	for _, element in pairs(self.elements) do
		if element.update then
			element:update(dt)
		end
	end
end

function Glorb:draw()
	for _, element in pairs(self.elements) do
		if element.draw then
			element:draw()
		end
	end
end

function Glorb:wheelmoved(x, y)
	for _, element in pairs(self.elements) do
		if element.wheelmoved then
			element:wheelmoved(x, y)
		end
	end
end

function Glorb:mousepressed(x, y, button, isTouch)
	local topmost = nil

	for _, element in pairs(self.elements) do
		if element.mousepressed and x >= element.x and x <= element.x + element.w and y >= element.y and y <= element.y + element.h then
			topmost = element
		end
	end

	if topmost then
		topmost:mousepressed(x, y, button, isTouch)
	end
end

return Glorb
