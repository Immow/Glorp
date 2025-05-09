local Glorp = require("libs.glorp")
local tests = require("libs.glorp.layouttests")
require("tprint")

DEBUG = false
local currentTest = 1

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
