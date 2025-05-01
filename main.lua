local Glorb = require("libs.glorb")
require("tprint")
Game = { currentLevel = 1 }

local glorb_alien = love.graphics.newImage("assets/glorp-alien.png")
local active = 1
local tests = {
	function() --1
		Glorb.newContainer({
			id = "test1",
			layout = "vertical",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
			scrollable = true,
			w = 400,
			h = 400,
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
			:addImage({ image = glorb_alien })
	end,
}
function love.load()
	tests[1]()
end

function love.keypressed(key, scancode, isrepeat)
	print(Game.currentLevel)
	if key == "p" then
		Glorb:purge()
	elseif key == "left" or key == "right" then
		if key == "left" then
			active = active - 1
			if active < 1 then
				active = #tests
			end
		else -- key == "right"
			active = active + 1
			if active > #tests then
				active = 1
			end
		end
		Glorb:purge()
		tests[active]()
	end
end

function love.mousepressed(x, y, button, isTouch)
	Glorb:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
	Glorb:mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
	Glorb:wheelmoved(x, y)
end

function love.mousemoved(x, y, dx, dy)
	Glorb:mousemoved(x, y, dx, dy)
end

function love.update(dt)
	Glorb:update(dt)
end

function love.draw()
	love.window.setTitle("active test " .. active)
	Glorb:draw()
end
