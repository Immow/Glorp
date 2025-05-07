local Glorb = require("libs.glorb")
require("tprint")
Game = { currentLevel = 1 }
DEBUG = false

local glorb_alien = love.graphics.newImage("assets/glorp-alien.png")
local mainContainer
local scrollContainer
local scrollContainer2

mainContainer = Glorb.newContainer({
		id = "mainContainer",
		x = 100,
		y = 100,
		w = 300,
		h = 400,
		layout = "vertical",
		alignment = { horizontal = "center", vertical = "bottom" },
		scrollable = true,
		-- scrollBar = {
		-- 	bar = { color = { 1, 0, 0, 1 } },
		-- 	track = { showScrollTrack = true }
		-- }
	})
	:addForm({ text = "test", previewText = "test2" })
-- :addDropDown({
-- 	options = {
-- 		{ name = "Apple",  value = "apple" },
-- 		{ name = "Banana", value = "banana" },
-- 	},
-- 	onSelect = function(i, val)
-- 		print("Selected:", i, val.value)
-- 	end
-- })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addButton({ label = "test" })
-- :addDropDown({
-- 	options = {
-- 		{ name = "Apple",  value = "apple" },
-- 		{ name = "Banana", value = "banana" },
-- 	},
-- 	onSelect = function(i, val)
-- 		print("Selected:", i, val.value)
-- 	end
-- })

-- mainContainer:addText({ text = "Hello Glorb!", w = 280, align = "center" })
-- for i = 1, 10 do
-- 	mainContainer:addImage({ image = glorb_alien })
-- end

-- scrollContainer = Glorb.newContainer({
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
-- 	scrollContainer:addImage({ image = glorb_alien })
-- end

-- scrollContainer2 = Glorb.newContainer({
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
	Glorb:keypressed(key, scancode, isrepeat)
	if key == "d" then
		DEBUG = not DEBUG
	end
end

function love.textinput(text)
	Glorb:textinput(text)
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
	Glorb:draw()
end
