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
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --2
		Glorb.newContainer({
			id = "test1",
			layout = "vertical",
			alignment = { horizontal = "left", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --3
		Glorb.newContainer({
			id = "test1",
			layout = "vertical",
			alignment = { horizontal = "right", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --4
		Glorb.newContainer({
			id = "test1",
			layout = "vertical",
			alignment = { horizontal = "center", vertical = "top" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --5
		Glorb.newContainer({
			id = "test1",
			layout = "vertical",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --6
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "vertical",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --7
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "vertical",
			alignment = { horizontal = "left", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end,

	function() --8
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "vertical",
			alignment = { horizontal = "right", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end
	,

	-- Layout Horizontal

	function() --9
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end
	,

	function() --10
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "top" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end
	,

	function() --11
		Glorb.newContainer({
			id = "test1",
			x = 150,
			y = 100,
			w = 250,
			h = 100,
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
	end
	,

	function() --12
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			w = 250,
			h = 100,
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.newContainer({
			id = "test2",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test2", "test1", "bottom")
		Glorb.newContainer({
			id = "test3",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test3", "test1", "left")
		Glorb.newContainer({
			id = "test4",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test4", "test1", "top")
		Glorb.newContainer({
			id = "test5",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "bottom" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test5", "test1", "right")
	end
	,

	function() --13
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			w = 250,
			h = 100,
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 }
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.newContainer({
			id = "test2",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 }
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test2", "test1", "bottom")
		Glorb.newContainer({
			id = "test3",
			layout = "horizontal",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 }
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
		Glorb.attach("test3", { "test1", "test2" }, "right")
	end
	,

	function() --14
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			layout = "vertical",
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 }
		})
			:addImage({ image = glorb_alien })
	end
	,

	function() --15
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			w = 200,
			h = 200,
			layout = "vertical",
			scrollable = true,
			alignment = { horizontal = "center", vertical = "center" },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 }
		})
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
	end
	,

	function() --16
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			w = 200,
			h = 200,
			layout = "vertical",
			scrollable = true,
			showScrollbar = true,
			alignment = { horizontal = "center", vertical = "center" },
			bar = { w = 20 },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButton({ label = "button1" })
			:addButton({ label = "button2" })
			:addButton({ label = "button3" })
			:addButton({ label = "button4" })
			:addButton({ label = "button5" })
			:addButton({ label = "button6" })
			:addButton({ label = "button7" })
			:addButton({ label = "button8" })
			:addImage({ image = glorb_alien })
			:addButton({ label = "button10" })
			:addImage({ image = glorb_alien })
	end
	,
	function() --17
		Glorb.newContainer({
			id = "test1",
			x = 200,
			y = 200,
			w = 200,
			h = 200,
			layout = "vertical",
			scrollable = true,
			showScrollbar = true,
			alignment = { horizontal = "center", vertical = "center" },
			bar = { w = 20 },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addButtonList({
				list = { "Level1", "Level2", "Level3", "Level4", "Level5", "Level6", "Level7", "Level8" },
				w = 100,
				h = 40,
				target = Game,
				property = "currentLevel"
			})
	end,

	function() --18
		local a = Glorb.newContainer({
				id = "test1",
				-- x = 200,
				-- y = 200,
				w = 200,
				h = 200,
				layout = "vertical",
				-- scrollable = true,
				-- showScrollbar = true,
				alignment = { horizontal = "center", vertical = "center" },
				bar = { w = 20 },
				borderColor = { 1, 1, 1, 1 },
				backgroundColor = { 1, 0, 0, 0.5 },
			})
			:addButtonList({
				list = { "Level1", "Level2", "Level3", "Level4", "Level5", "Level6", "Level7", "Level8" },
				w = 100,
				h = 40,
				target = Game,
				property = "currentLevel"
			})
		local b = Glorb.newContainer({
				id = "test2",
				-- x = 200,
				-- y = 200,
				w = 200,
				h = 200,
				layout = "vertical",
				-- scrollable = true,
				-- showScrollbar = true,
				alignment = { horizontal = "center", vertical = "center" },
				bar = { w = 20 },
				borderColor = { 1, 1, 1, 1 },
				backgroundColor = { 1, 0, 0, 0.5 },
			})
			:addButtonList({
				list = { "Level1", "Level2", "Level3", "Level4", "Level5", "Level6", "Level7", "Level8" },
				w = 100,
				h = 40,
				target = Game,
				property = "currentLevel"
			})

		Glorb.newContainer({
			id = "test3",
			x = 200,
			y = 200,
			w = 500,
			h = 200,
			layout = "horizontal",
			scrollable = true,
			showScrollbar = true,
			alignment = { horizontal = "center", vertical = "center" },
			bar = { w = 20 },
			borderColor = { 1, 1, 1, 1 },
			backgroundColor = { 1, 0, 0, 0.5 },
		})
			:addContainer(a)
			:addContainer(b)
	end,
}

function love.load()
	tests[18]()
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
