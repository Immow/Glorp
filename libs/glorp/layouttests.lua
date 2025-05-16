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

local subContainer1 = Glorp.newContainer({
		id = "subContainer1",
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

local subContainer2 = Glorp.newContainer({
		id = "subContainer2",
		layout = "vertical",
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10
	})
	:addImage({ image = glorp_alien, id = "glorp_alien" })

layoutTests[2]:addContainer(subContainer1)
layoutTests[2]:addContainer(subContainer2)

layoutTests[3] = Glorp.newContainer({
		enabled = false,
		id = "layoutTests3",
		x = 100,
		y = 100,
		w = 300,
		h = 300,
		layout = "vertical",
		scrollable = true,
		alignment = { horizontal = "left", vertical = "center" },
		padding = 10,
		titleBar = true,
		draggable = true
	})
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })
	:addImage({ image = glorp_alien })

return layoutTests
