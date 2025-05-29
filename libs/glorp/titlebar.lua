local folder_path = (...):match("(.-)[^%.]+$")
local Text        = require(folder_path .. "text")

local TitleBar    = {}
TitleBar.__index  = TitleBar

function TitleBar.new(settings)
	local instance        = setmetatable({}, TitleBar)
	instance.id           = settings.id or nil
	instance.enabled      = (settings.titleBar and settings.titleBar.enabled) or false
	instance.x            = settings.x or 0
	instance.y            = settings.y or 0
	instance.w            = settings.w or 100
	instance.h            = settings.h or 50
	instance.cornerRadius = (settings.titleBar and settings.titleBar.cornerRadius) or 0
	instance.h            = (settings.titleBar and settings.titleBar.h) or 24
	instance.color        = (settings.titleBar and settings.titleBar.color) or { 0.2, 0.2, 0.2, 1 }
	instance.font         = (settings.titleBar and settings.titleBar.font) or love.graphics.getFont()
	local tb              = settings.titleBar or {}

	instance.text         = Text.new(tb.text or {})

	if instance.cornerRadius > instance.h / 2 then
		print("Warning: TitleBar cornerRadius too large, clamped to height/2")
		instance.cornerRadius = instance.h / 2
	end

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
	local fontHeight = self.font:getHeight()
	local paddingX = self.cornerRadius or 0
	local paddingY = self.h / 2 - fontHeight / 2
	self.text:updateLayout(self.x + paddingX, self.y + paddingY, self.w - (paddingX * 2))
end

function TitleBar:draw()
	if self.enabled then
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.cornerRadius)
		love.graphics.rectangle("fill", self.x, self.y + self.h / 2, self.w, self.h / 2) -- cover bottom rounded corners
		self.text:draw()
	end
end

return TitleBar
