local Container = require("container")
require("tprint")

local windows = {}
function love.load()
	windows.window1 = Container.new({ x = 50, y = 50, w = 250, layout = "horizontal", borderColor = { 1, 0, 0, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
		:addButton({ w = 80, h = 50, label = "test1" })
		:addButton({ w = 50, h = 80, label = "test2" })
	windows.window2 = Container.new({ layout = "horizontal", borderColor = { 1, 1, 0, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
		:attach(windows.window1, "right")
		:addButton({ w = 100, h = 50, label = "test3" })
	windows.window3 = Container.new({ layout = "horizontal", borderColor = { 1, 0, 0, 1 }, backgroundColor = { 0, 0, 1, 0.5 } })
		:attach({ windows.window1, windows.window2 }, "bottom")
		:addButton({ w = 50, h = 50, label = "test4" })
		:addButton({ w = 50, h = 50, label = "test5" })

	-- print(Tprint(window))
end

function love.mousepressed(x, y, button, isTouch)
	for _, window in pairs(windows) do
		window:mousepressed(x, y, button, isTouch)
	end
end

function love.draw()
	for _, window in pairs(windows) do
		window:draw()
	end
end
