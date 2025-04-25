local Lovemeasure = {}

local points = {}

function Lovemeasure:mousepressed(x, y, button, isTouch)
	if #points == 0 then
		points[1] = { x = x, y = y }
	elseif #points == 1 then
		print("x: " .. points[1].x - x, "y: " .. points[1].y - y)
		points = {}
	end
	-- print(Tprint(points))
end

function Lovemeasure:draw()
	local font = love.graphics.getFont() or love.graphics.newFont(12)
	local mx, my = love.mouse.getPosition()

	local text = string.format("x: %d y: %d", mx, my)
	local width = font:getWidth(text) + 10
	local height = font:getHeight()

	local winWidth, winHeight = love.graphics.getDimensions()
	local x = math.min(mx + 10, winWidth - width - 10)
	local y = math.min(my - 5, winHeight - height)

	-- Draw background
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill", x, y, width + 10, height + 4)

	-- Draw text
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(text, x + 5, y)
end

return Lovemeasure
