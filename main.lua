local Glorb = require("libs.glorb")
require("tprint")

local active = 1
local tests = {}

tests[1] = function()
	Glorb.newContainer({
		id = "test1",
		x = 150,
		y = 100,
		w = 250,
		h = 100,
		scrollable = true,
		layout = "vertical",
		alignment = { horizontal = "center", vertical = "top" },
		borderColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 0, 0, 0.5 },
	})
		:addButton({ label = "button1" })
		:addButton({ label = "button2" })
		:addButton({ label = "button3" })
end

tests[2] = function()
	Glorb.newContainer({
		id = "test1",
		x = 150,
		y = 100,
		w = 250,
		h = 100,
		layout = "vertical",
		alignment = { horizontal = "center", vertical = "top" },
		borderColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 0, 0, 0.5 },
	})
		:addButton({ label = "button1" })
end

function love.load()
	tests[1]()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "p" then
		Glorb:purge()
	elseif key == "left" then
		if active > 1 then
			active = active - 1
			Glorb:purge()
			tests[active]()
		end
	elseif key == "right" then
		if active < #tests then
			active = active + 1
			Glorb:purge()
			tests[active]()
		end
	end
end

function love.mousepressed(x, y, button, isTouch)
	Glorb:mousepressed(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
	Glorb:wheelmoved(x, y)
end

function love.draw()
	love.window.setTitle("active test " .. active)
	Glorb:draw()
end
