local TitleBar   = {}
TitleBar.__index = TitleBar

function TitleBar.new(settings)
	local instance        = setmetatable({}, TitleBar)
	instance.x            = settings.x or 0
	instance.y            = settings.y or 0
	instance.w            = settings.w or 100
	instance.h            = settings.h or 50
	instance.cornerRadius = (settings.titleBar and settings.titleBar.cornerRadius) or 10
	instance.h            = (settings.titleBar and settings.titleBar.h) or 24
	instance.color        = (settings.titleBar and settings.titleBar.color) or { 0.2, 0.2, 0.2, 1 }
	instance.text         = (settings.titleBar and settings.titleBar.text) or instance.label or instance.id or ""
	instance.enabled      = (settings.titleBar and settings.titleBar.enabled) or false

	return instance
end

function TitleBar:isMouseInside(mx, my)
	return self.enabled and mx >= self.x and mx <= self.x + self.w
		and my >= self.y and my <= self.y + self.h
end

function TitleBar:updateLayout(x, y, w)
	self.x = x
	self.y = y
	self.w = w
end

function TitleBar:draw()
	if self.enabled then
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.cornerRadius)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(self.text, self.x + 5, self.y + 4)
	end
end

return TitleBar
