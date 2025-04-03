local Container = require("container")
require("tprint")
local window1
local window2
local window3
function love.load()
	window1 = Container.new({ x = 50, y = 50, w = 250, layout = "horizontal", borderColor = { 1, 0, 0, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
		:addButton({ w = 80, h = 50, label = "test1" })
		:addButton({ w = 50, h = 80, label = "test2" })
	window2 = Container.new({ layout = "horizontal", borderColor = { 1, 1, 0, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
		:attach(window1, "right")
		:addButton({ w = 100, h = 50, label = "test3" })
	window3 = Container.new({ layout = "horizontal", borderColor = { 1, 0, 0, 1 }, backgroundColor = { 0, 0, 1, 0.5 } })
		:attach({ window1, window2 }, "bottom")
		:addButton({ w = 50, h = 50, label = "test4" })
		:addButton({ w = 50, h = 50, label = "test5" })

	-- print(Tprint(window))
end

function love.draw()
	window1:draw()
	window2:draw()
	window3:draw()
end
