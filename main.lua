local Glorp = require("libs.glorp")
require("tprint")
Game = { currentLevel = 1 }
DEBUG = false

local glorp_alien = love.graphics.newImage("assets/glorp-alien.png")
local mainContainer
local scrollContainer
local scrollContainer2

mainContainer = Glorp.newContainer({
		id = "mainContainer",
		x = 100,
		y = 100,
		w = 300,
		h = 400,
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		scrollable = true,
		-- scrollBar = {
		-- 	bar = { color = { 1, 0, 0, 1 } },
		-- 	track = { showScrollTrack = true }
		-- }
	})
	:addRadioButton({
		label = "test",
		onRelease = function(isChecked)
			if isChecked then print("enabled") else print("disabled") end
		end
	})
	:addCheckBox({
		onRelease = function(isChecked)
			if isChecked then print("enabled") else print("disabled") end
		end
	})
	:addSlider({
		id = "A",
		w = 200,
		h = 20,
		startValue = 25,
		orientation = "horizontal",
		onRelease = function(val)
			print(
				"Slider released at:", val)
		end
	})
	:addForm({
		id = "loginForm",
		fields = {
			{ name = "username", label = "Username", value = "" },
			{ name = "password", label = "Password", value = "" },
		},
		onSubmit = function(data)
			print("Form submitted:")
			for k, v in pairs(data) do
				print(k, v)
			end
		end
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
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addButton({ label = "test" })
	:addDropDown({
		options = {
			{ name = "Apple",  value = "apple" },
			{ name = "Banana", value = "banana" },
		},
		onSelect = function(i, val)
			print("Selected:", i, val.value)
		end
	})

-- mainContainer:addText({ text = "Hello Glorp!", w = 280, align = "center" })
-- for i = 1, 10 do
-- 	mainContainer:addImage({ image = glorp_alien })
-- end

-- scrollContainer = Glorp.newContainer({
-- 		id = "scrollContainer",
-- 		layout = "vertical",
-- 		alignment = { horizontal = "center", vertical = "center" },
-- 		borderColor = { 1, 1, 1, 1 },
-- 		backgroundColor = { 1, 0, 0, 0.5 },
-- 		scrollDirection = "vertical",
-- 		scrollable = true,
-- 		w = 200,
-- 		h = 200,
-- 	})
-- 	:addDropDown({
-- 		options = {
-- 			{ name = "Apple",  value = "apple" },
-- 			{ name = "Banana", value = "banana" },
-- 		},
-- 		onSelect = function(i, val)
-- 			print("Selected:", i, val.value)
-- 		end
-- 	})
-- 	:addButton({ label = "test" })

-- for i = 1, 10 do
-- 	scrollContainer:addImage({ image = glorp_alien })
-- end

-- scrollContainer2 = Glorp.newContainer({
-- 	id = "scrollContainer2",
-- 	layout = "vertical",
-- 	alignment = { horizontal = "center", vertical = "center" },
-- 	-- scrollDirection = "vertical",
-- 	borderColor = { 1, 1, 1, 1 },
-- 	backgroundColor = { 1, 0, 0, 0.5 },
-- 	scrollable = true,
-- 	w = 200,
-- 	h = 300,
-- })

-- local list = {
-- 	"A", "B", "C", "D", "E", "D", "F", "G", "H", "I"
-- }

-- for i = 1, 10 do
-- 	scrollContainer2:addButton({ label = "test " .. i, fn = function() print(list[i]) end })
-- end


-- mainContainer:addContainer(scrollContainer)
-- mainContainer:addContainer(scrollContainer2)

function love.load()

end

function love.keypressed(key, scancode, isrepeat)
	Glorp:keypressed(key, scancode, isrepeat)
	-- if key == "d" then
	-- 	DEBUG = not DEBUG
	-- end
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
