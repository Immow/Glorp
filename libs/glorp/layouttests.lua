local Glorp = require("libs.glorp")
local glorp_alien = love.graphics.newImage("assets/glorp-alien.png")
local layoutTests = {}

layoutTests[1] = Glorp.newContainer({
		id = "layoutTests1",
		x = 100,
		y = 100,
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10
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
		padding = 10
	})
	:addRadioButton({
		label = "test",
		onRelease = function(isChecked)
			if isChecked then print("enabled") else print("disabled") end
		end
	})

return layoutTests
