local Glorb = require("libs.glorb")
require("tprint")

function love.load()
	Glorb.newContainer({ id = "test1", w = 250, h = 200, x = 150, y = 100, layout = "vertical", alignment = { horizontal = "left", vertical = "center" }, borderColor = { 1, 1, 1, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
		:addButton({ w = 80, h = 50, label = "button1" })
		:addButton({ w = 50, h = 80, label = "button2" })
	Glorb.newContainer({ id = "test2", layout = "horizontal", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
		:addButton({ w = 100, h = 50, label = "button3" })
	Glorb.attach("test2", "test1", "right")
	Glorb.newContainer({ id = "test3", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 0, 1, 0.5 } })
		:addButton({ w = 100, h = 50, label = "button5" })
	Glorb.attach("test3", { "test1", "test2" }, "bottom")
	Glorb.newContainer({ id = "test4", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
		:addButton({ w = 50, h = 50, label = "button6" })
	Glorb.attach("test4", { "test1", "test3" }, "left")
	Glorb.newContainer({ id = "test5", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
		:addButton({ w = 75, h = 90, label = "button7" })
	Glorb.attach("test5", { "test1", "test2" }, "top")
end

function love.mousepressed(x, y, button, isTouch)
	Glorb:mousepressed(x, y, button, isTouch)
end

function love.draw()
	Glorb:draw()
end
