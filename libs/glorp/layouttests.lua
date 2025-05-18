local Glorp = require("libs.glorp")
local glorp_alien = love.graphics.newImage("assets/glorp-alien.png")
local layoutTests = {}

layoutTests[1] = Glorp.newContainer({
		id = "layoutTests1",
		x = 100,
		y = 100,
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10,
		titleBar = true,
		draggable = true
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
		value = 0.25,
		orientation = "horizontal",
		onRelease = function(val)
			print(
				"Slider released at:", val)
		end
	})
	:addForm({
		id = "loginForm",
		fields = {
			{ name = "username", label = "Username" },
			{ name = "password", label = "Password" },
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

layoutTests[2] = Glorp.newContainer({
		enabled = false,
		id = "layoutTests2",
		x = 100,
		y = 100,
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10,
		titleBar = true,
		draggable = true
	})
	:addRadioButton({
		label = "test",
		checked = true,
		onRelease = function(isChecked)
			local child = Glorp:getElementById("glorp_alien")
			if isChecked then child.enabled = true else child.enabled = false end
		end
	})

local layoutTests2Sub1 = Glorp.newContainer({
		id = "layoutTests2sub1",
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10
	})
	:addSlider({
		value = 1,
		onRelease = function(val)
			local image = Glorp:getElementById("glorp_alien")
			if image then image.color[4] = val end
		end
	})

local layoutTests2Sub2 = Glorp.newContainer({
		id = "layoutTests2sub2",
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10
	})
	:addImage({ image = glorp_alien, id = "glorp_alien" })

layoutTests[2]:addContainer(layoutTests2Sub1)
layoutTests[2]:addContainer(layoutTests2Sub2)

layoutTests[3] = Glorp.newContainer({
	enabled = false,
	id = "layoutTests3",
	x = 100,
	y = 100,
	w = 300,
	h = 300,
	layout = "horizontal",
	scrollDirection = "horizontal",
	scrollable = true,
	alignment = { horizontal = "right", vertical = "top" },
	padding = 0,
	titleBar = true,
	draggable = true
})
for i = 1, 10 do
	layoutTests[3]:addButton({ label = "test " .. i })
end

layoutTests[4] = Glorp.newContainer({
	enabled = false,
	id = "layoutTests4",
	x = 100,
	y = 100,
	w = 400,
	h = 200,
	layout = "horizontal",
	alignment = { horizontal = "right", vertical = "top" },
	padding = 0,
	titleBar = true,
	draggable = true,
	scrollable = true,
	scrollDirection = "horizontal"
})

local layoutTests4Sub1 = Glorp.newContainer({
	id = "layoutTests4Sub1",
	layout = "horizontal",
})
for i = 1, 20 do
	layoutTests4Sub1:addButton({ label = "test " .. i })
end

local layoutTests4Sub2 = Glorp.newContainer({
	id = "layoutTests4Sub2",
	layout = "horizontal",
})
for i = 1, 20 do
	layoutTests4Sub2:addButton({ label = "test " .. i })
end

layoutTests[4]:addContainer(layoutTests4Sub1)
layoutTests[4]:addContainer(layoutTests4Sub2)

-- layoutTests[5] = Glorp.newContainer({
-- 	enabled = false,
-- 	id = "layoutTests5",
-- 	x = 100,
-- 	y = 100,
-- 	w = 400,
-- 	h = 400,
-- 	layout = "horizontal",
-- 	alignment = { horizontal = "right", vertical = "top" },
-- 	padding = 10,
-- 	titleBar = true,
-- 	draggable = true,
-- 	-- scrollDirection = "vertical"
-- })
-- for i = 1, 3 do
-- 	layoutTests[5]:addButton({ label = "test " .. i })
-- end

return layoutTests
