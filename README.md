# Glorp (work in progress)

**Glorp** is a lightweight, modular GUI library for [LÖVE](https://love2d.org/) that provides a flexible way to build user interfaces using containers, scrollbars, buttons, and text elements. Inspired by simple layout systems and designed with puzzle and tool games in mind, Glorp offers fine-grained control over layout, visuals, and structure.

---

## Features

- 🧱 **Containers**: Stack and position elements manually or through custom logic
- 🖱️ **Scrollbars**: Vertical and horizontal, with customizable bar and track appearance
- ✏️ **Text elements**: Aligned, wrapped, and font-controlled text rendering
- 🎨 **Fully customizable**: Bring your own colors, images, and layout logic
- ⚡ Minimal, no dependencies
- etc
---

## Getting Started

### Installation

### example usage:
```lua
local Glorp = require("libs.glorp")
local mainContainer

function love.load()
	mainContainer = Glorp.newContainer({
		id = "mainContainer",
		x = 100,
		y = 100,
		w = 300,
		h = 400,
		scrollBar = {
			bar = { color = { 1, 0, 0, 1 } },
			track = { showScrollTrack = true }
		}
	})

	mainContainer:addText({ text = "Hello Glorp!", w = 280, align = "center" })
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

-- more will follow when the libs grows
```
