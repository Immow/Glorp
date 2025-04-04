local Glorb = require("libs.glorb")
require("tprint")

function love.load()
	Glorb.newContainer({ id = "test1", w = 250, h = 300, x = 50, y = 50, layout = "vertical", alignment = { horizontal = "center", vertical = "center" }, borderColor = { 1, 1, 1, 1 }, backgroundColor = { 1, 0, 0, 0.5 } })
		:addButton({ w = 80, h = 50, label = "button" })
		:addButton({ w = 50, h = 80, label = "button" })
	Glorb.newContainer({ id = "test2", layout = "horizontal", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 1, 0, 0.5 } })
	Glorb.attach("test2", "test1", "right")
		:addButton({ w = 100, h = 50, label = "button" })
	Glorb.newContainer({ id = "test3", borderColor = { 1, 1, 1, 1 }, backgroundColor = { 0, 0, 1, 0.5 } })
	Glorb.attach("test3", { "test1", "test2" }, "bottom")
		:addButton({ w = 100, h = 50, label = "button" })
end

function love.mousepressed(x, y, button, isTouch)
	Glorb:mousepressed(x, y, button, isTouch)
end

function love.draw()
	Glorb:draw()
end
