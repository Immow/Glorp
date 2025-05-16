local Glorp = require("libs.glorp")
local tests = require("libs.glorp.layouttests")
require("tprint")

DEBUG = false
local currentTest = 1

Glorp.newContainer({
	id = "layoutTests11",
	titlebarText = "layoutTests1",
	x = 100,
	y = 100,
	w = 200,
	layout = "vertical",
	alignment = { horizontal = "left", vertical = "center" },
	padding = 10,
	titleBar = true,
	draggable = true
})
	:addDropDown({
		options = {
			{ name = "Apple",  value = "apple" },
			{ name = "Banana", value = "banana" },
		},
		onSelect = function(i, val)
			print("Selected:", i, val.value)
		end,
		bgColor = { 0.8, 0.8, 0.8, 1 }
	})

Glorp.newContainer({
	id = "layoutTests12",
	titlebarText = "layoutTests2",
	x = 300,
	y = 100,
	w = 200,
	layout = "vertical",
	alignment = { horizontal = "left", vertical = "center" },
	padding = 10,
	titleBar = true,
	draggable = true
})
	:addDropDown({
		options = {
			{ name = "Apple",  value = "apple" },
			{ name = "Banana", value = "banana" },
		},
		onSelect = function(i, val)
			print("Selected:", i, val.value)
		end
	})

function love.load()

end

function love.keypressed(key, scancode, isrepeat)
	Glorp:keypressed(key, scancode, isrepeat)

	if key == "right" then
		Glorp:setEnabled(tests[currentTest], false)

		if currentTest < #tests then
			currentTest = currentTest + 1
		else
			currentTest = 1
		end

		Glorp:setEnabled(tests[currentTest], true)
	elseif key == "lctrl" then
		DEBUG = not DEBUG
	end
end

function love.textinput(text)
	Glorp:textinput(text)
end

function love.mousepressed(x, y, button, isTouch)
	Glorp:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
	Glorp:mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
	Glorp:wheelmoved(x, y)
end

function love.mousemoved(x, y, dx, dy)
	Glorp:mousemoved(x, y, dx, dy)
end

function love.update(dt)
	Glorp:update(dt)
end

function love.draw()
	Glorp:draw()
end
