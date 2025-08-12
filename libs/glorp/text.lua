local Text = {}
Text.__index = Text

function Text.new(settings, glorp, parent)
	local instance  = setmetatable({}, Text)
	instance.id     = settings.id or nil
	instance.type   = "text"
	instance.text   = settings.text or settings.label or settings.id or ""
	instance.font   = settings.font or love.graphics:getFont()
	instance.color  = settings.color or { 1, 1, 1, 1 }
	instance.align  = settings.align or "left"    -- left, center, right
	instance.x      = settings.x or 0
	instance.parent = parent or nil
	instance.y      = settings.y or 0

	-- 👇 Old addText logic moved here
	if (not settings.w) and parent and parent.w and parent.w ~= 0 then
		local availableWidth = parent.w
			- (parent.padding and parent.padding.left or 0)
			- (parent.padding and parent.padding.right or 0)

		local font = settings.font or love.graphics:getFont()
		local textStr = settings.text or settings.label or settings.id or ""
		settings.w = math.min(font:getWidth(textStr), availableWidth)
	end

	instance.w         = settings.w or math.min(instance.font:getWidth(instance.text), 400)

	local lineHeight   = instance.font:getHeight()
	local _, wrapCount = instance.font:getWrap(instance.text, instance.w)
	instance.h         = #wrapCount * lineHeight

	instance.enabled   = settings.enabled ~= false
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
