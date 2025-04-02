-- require("tprint")

-- local GUI = {}
-- GUI.__index = GUI

-- function GUI.createContainer(params)
-- 	local self = setmetatable({}, GUI)
-- 	self.x = params.x or 0
-- 	self.y = params.y or 0
-- 	self.w = 0 -- Start with 0 width, will be calculated
-- 	self.h = 0 -- Start with 0 height, will be calculated
-- 	self.layout = params.layout or "vertical"
-- 	self.children = {}
-- 	self.spacing = params.spacing or 10
-- 	return self
-- end

-- function GUI:addButton(params)
-- 	local button = {
-- 		x = 0,
-- 		y = 0,
-- 		w = params.w or 50,
-- 		h = params.h or 20,
-- 		label = params.label or "Button"
-- 	}

-- 	table.insert(self.children, button)
-- 	self:updateLayout()
-- 	return self -- Allow chaining
-- end

-- function GUI:newContainer(params)
-- 	local container = GUI.createContainer(params)
-- 	table.insert(self.children, container)
-- 	self:updateLayout()
-- 	return container -- Corrected: return the new container for chaining
-- end

-- function GUI:updateLayout()
-- 	local offset = 0
-- 	local maxWidth, maxHeight = 0, 0

-- 	for _, child in ipairs(self.children) do
-- 		if self.layout == "horizontal" then
-- 			child.x = self.x + offset
-- 			child.y = self.y
-- 			offset = offset + child.w + self.spacing
-- 			maxHeight = math.max(maxHeight, child.h)
-- 		else -- Vertical layout
-- 			child.x = self.x
-- 			child.y = self.y + offset
-- 			offset = offset + child.h + self.spacing
-- 			maxWidth = math.max(maxWidth, child.w)
-- 		end
-- 	end

-- 	if self.layout == "horizontal" then
-- 		self.w = offset - self.spacing -- Remove last added spacing
-- 		self.h = maxHeight
-- 	else
-- 		self.w = maxWidth
-- 		self.h = offset - self.spacing -- Remove last added spacing
-- 	end

-- 	-- Ensure nested containers update their own layout
-- 	for _, child in ipairs(self.children) do
-- 		if not child.label then -- If it's a container
-- 			child:updateLayout()
-- 		end
-- 	end
-- end

-- function GUI:draw()
-- 	-- Draw container
-- 	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

-- 	-- Draw children (buttons or nested containers)
-- 	for _, child in ipairs(self.children) do
-- 		if child.label then -- Button
-- 			love.graphics.rectangle("line", child.x, child.y, child.w, child.h)
-- 			love.graphics.printf(child.label, child.x, child.y + 5, child.w, "center")
-- 		else -- Nested container
-- 			child:draw()
-- 		end
-- 	end
-- end

-- -- Example usage
-- local WW, WH = love.graphics.getDimensions()
-- local container

-- function love.load()
-- 	container = GUI.createContainer({ x = 10, y = 10, layout = "horizontal", spacing = 10 })
-- 		:newContainer({ layout = "vertical" }) -- <-- this should be a block of buttons on the left
-- 		:addButton({ w = 80, h = 30, label = "Play" })
-- 		:addButton({ w = 80, h = 30, label = "Exit" })
-- 		:newContainer({ layout = "vertical" }) -- <-- this should be a block of buttons on the right of the previous block
-- 		:addButton({ w = 80, h = 30, label = "Test1" })
-- 		:addButton({ w = 80, h = 30, label = "Test2" })
-- 	container:updateLayout() -- Ensure layout updates correctly

-- 	print(Tprint(container))
-- end

-- function love.draw()
-- 	container:draw()
-- end
