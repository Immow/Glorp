# Glorb (work in progress)

**Glorb** is a lightweight, modular GUI library for [LÖVE](https://love2d.org/) that provides a flexible way to build user interfaces using containers, scrollbars, buttons, and text elements. Inspired by simple layout systems and designed with puzzle and tool games in mind, Glorb offers fine-grained control over layout, visuals, and structure.

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
local Glorb = require("libs.glorb")
local mainContainer

function love.load()
	mainContainer = Glorb.newContainer({
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

	mainContainer:addText({ text = "Hello Glorb!", w = 280, align = "center" })
end

function love.update(dt)
	Glorb:update(dt)
end

function love.draw()
	Glorb:draw()
end
```
