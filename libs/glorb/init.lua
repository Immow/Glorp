local folder_path = (...):match("(.-)[^%.]+$")

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
		if not Glorb.elements[id] then
			error("Target element with ID " .. id .. " not found.")
		end
		table.insert(targets, Glorb.elements[id])
	end

	for i = 1, #targets do
		if side == "bottom" then
			element.x = targets[1].x
			element.y = targets[1].y + targets[1].h
			element.w = element.w + targets[i].w
		elseif side == "right" then
			element.x = targets[1].x + targets[1].w
			element.y = targets[1].y
			element.h = element.h + targets[i].h
		end
	end

	return element
end

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
