-- local Container = require("glorb.container")
local Glorb = require("libs.glorb")
require("tprint")

-- local windows = {}
function love.load()
	-- windows.window1 = Container.new({ w = 250, h = 300, x = 50, y = 50, layout = "vertical", alignment = { horizontal = "center", vertical = "center" }, borderColor = { 1, 0, 0, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
	-- 	:addButton({ w = 80, h = 50, label = "test1" })
	-- 	:addButton({ w = 50, h = 80, label = "test2" })
	-- windows.window2 = Container.new({ layout = "horizontal", borderColor = { 1, 1, 0, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
	-- 	:attach(windows.window1, "right")
	-- 	:addButton({ w = 100, h = 50, label = "test3" })
	-- windows.window3 = Container.new({ layout = "horizontal", borderColor = { 1, 0, 0, 1 }, backgroundColor = { 0, 0, 1, 0.5 } })
	-- 	:attach({ windows.window1, windows.window2 }, "bottom")
	-- 	:addButton({ w = 50, h = 50, label = "test4" })
	-- 	:addButton({ w = 50, h = 50, label = "test5" })

	-- Glorb.Container.new({ id = "window1", x = 50, y = 50, w = 250, h = 150, label = "Test Window" })
	-- 	:addButton({ id = "btn1", x = 60, y = 60, w = 80, h = 50, label = "Click Me" })

	Glorb.newContainer({ id = "test1", w = 250, h = 300, x = 50, y = 50, layout = "vertical", alignment = { horizontal = "center", vertical = "center" }, borderColor = { 1, 0, 0, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
		:addButton({ w = 80, h = 50, label = "test1" })
		:addButton({ w = 50, h = 80, label = "test2" })
	Glorb.newContainer({ id = "test2", layout = "horizontal", borderColor = { 1, 1, 0, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
	Glorb.attach("test2", "test1", "right")
		:addButton({ w = 100, h = 50, label = "test3" })
end

function love.mousepressed(x, y, button, isTouch)
	-- for _, window in pairs(windows) do
	-- 	window:mousepressed(x, y, button, isTouch)
	-- end
	Glorb:mousepressed(x, y, button, isTouch)
end

function love.draw()
	-- for _, window in pairs(windows) do
	-- 	window:draw()
	-- end
	Glorb:draw()
end
