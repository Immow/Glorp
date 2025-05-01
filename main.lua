local Glorb = require("libs.glorb")
require("tprint")
Game = { currentLevel = 1 }

local glorb_alien = love.graphics.newImage("assets/glorp-alien.png")
local active = 1
local mainContainer
local scrollContainer

mainContainer = Glorb.newContainer({
		id = "mainContainer",
		layout = "vertical",
		alignment = { horizontal = "center", vertical = "center" },
		borderColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 1, 0, 0.5 },
		scrollable = true,
		w = 600,
		h = 400,
		showScrollbar = true,
	})
	:addButton({ label = "button1" })
	:addButton({ label = "button2" })
	:addImage({ image = glorb_alien })
	:addButton({ label = "button3" })

scrollContainer = Glorb.newContainer({
		id = "scrollContainer",
		layout = "vertical",
		alignment = { horizontal = "center", vertical = "center" },
		borderColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 0, 0, 0.5 },
		scrollable = true,
		w = 300,
		h = 300,
		showScrollbar = true,
	})
	:addButton({ label = "button1" })
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

mainContainer:addContainer(scrollContainer)
-- local tests = { mainContainer }


function love.load()
	-- tests[1]()
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
	-- mainContainer:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
	Glorb:mousereleased(x, y, button, isTouch)
	-- mainContainer:mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
	Glorb:wheelmoved(x, y)
	-- mainContainer:wheelmoved(x, y)
end

function love.mousemoved(x, y, dx, dy)
	Glorb:mousemoved(x, y, dx, dy)
	-- mainContainer:mousemoved(x, y, dx, dy)
end

function love.update(dt)
	Glorb:update(dt)
	-- mainContainer:update(dt)
end

function love.draw()
	-- love.window.setTitle("active test " .. active)
	Glorb:draw()
	-- mainContainer:draw()
end
