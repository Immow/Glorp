local Text = {}
Text.__index = Text

function Text.new(settings)
	local instance   = setmetatable({}, Text)
	instance.id      = settings.id or nil
	instance.type    = "text"
	instance.text    = settings.text or settings.label or settings.id or ""
	instance.font    = settings.font or love.graphics:getFont()
	instance.color   = settings.color or { 1, 1, 1, 1 }
	instance.align   = settings.align or "left" -- left, center, right
	instance.x       = settings.x or 0
	instance.y       = settings.y or 0
	instance.w       = settings.w or math.min(instance.font:getWidth(instance.text), love.graphics.getWidth())
	instance.h       = instance.font:getHeight()
	instance.enabled = settings.enabled ~= false
	return instance
end

function Text:updateLayout(x, y, w)
	self.x = x
	self.y = y
	self.w = w
end

function Text:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self.color)
	love.graphics.printf(self.text, self.x, self.y, self.w, self.align)
end

return Text
