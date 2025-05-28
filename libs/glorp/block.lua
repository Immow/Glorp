local Block = {}
Block.__index = Block

function Block.new(settings)
	local instance   = setmetatable({}, Block)
	instance.id      = settings.id or nil
	instance.type    = "block"
	instance.color   = settings.color or { 1, 1, 1, 1 }
	instance.x       = settings.x or 0
	instance.y       = settings.y or 0
	instance.w       = settings.w or 50
	instance.h       = settings.h or 50
	instance.enabled = settings.enabled ~= false

	return instance
end

function Block:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Block
