local Form = {}
Form.__index = Form

function Form.new(settings)
	local instance             = setmetatable({}, Form)
	instance.id                = settings.id or nil
	instance.type              = "form"
	instance.font              = settings.font or love.graphics.getFont()
	instance.color             = settings.color or { 1, 1, 1, 1 }
	instance.x                 = settings.x or 0
	instance.y                 = settings.y or 0
	instance.w                 = settings.w or 250
	instance.h                 = settings.h or instance.font:getHeight() + 4
	instance.offset            = 4
	instance.limit             = settings.limit or nil
	instance.backgroundColor   = settings.backgroundColor or { 0, 0, 0, 0.2 }
	instance.borderColor       = settings.borderColor or { 0.7, 0.7, 0.7, 1 }
	instance.activeBorderColor = settings.activeBorderColor or { 1, 1, 1, 1 }
	instance.onSubmit          = settings.onSubmit or nil
	instance.fields            = settings.fields or {}
	instance.activeFieldIndex  = 1

	instance.cursorTimer       = 0
	instance.cursorDir         = 1
	instance.cursorBlinkSpeed  = 1.5

	return instance
end

function Form:update(dt)
	if self.cursorTimer < 0 then
		self.cursorTimer = 0
		self.cursorDir = 1
	elseif self.cursorTimer > 1 then
		self.cursorTimer = 1
		self.cursorDir = -1
	end
	self.cursorTimer = self.cursorTimer + (dt * self.cursorBlinkSpeed) * self.cursorDir
end

function Form:textinput(t)
	local field = self.fields[self.activeFieldIndex]
	if field and (not self.limit or #field.value < self.limit) then
		field.value = field.value .. t
	end
end

function Form:keypressed(key)
	local field = self.fields[self.activeFieldIndex]
	if not field then return end

	if key == "backspace" then
		field.value = field.value:sub(1, -2)
	elseif key == "return" or key == "kpenter" then
		if self.onSubmit then
			local result = {}
			for _, f in ipairs(self.fields) do
				result[f.name] = f.value
			end
			self.onSubmit(result)
		end
	elseif key == "tab" then
		self.activeFieldIndex = self.activeFieldIndex % #self.fields + 1
	end
end

function Form:mousepressed(mx, my, mouseButton)
	if mouseButton ~= 1 then return false end

	local fieldHeight = self.h
	for i, field in ipairs(self.fields) do
		local y = self.y + (i - 1) * (fieldHeight + 10)
		local inputX = self.x + 100
		if mx >= inputX and mx <= inputX + self.w - 100 and my >= y and my <= y + fieldHeight then
			self.activeFieldIndex = i
			return true
		end
	end
	return false
end

function Form:draw()
	local fieldHeight = self.h
	for i, field in ipairs(self.fields) do
		local y = self.y + (i - 1) * (fieldHeight + 10)
		local inputX = self.x + 100

		love.graphics.setColor(1, 1, 1)
		love.graphics.print(field.label, self.x, y)

		love.graphics.setColor(self.backgroundColor)
		love.graphics.rectangle("fill", inputX, y, self.w - 100, fieldHeight)

		love.graphics.setColor(i == self.activeFieldIndex and self.activeBorderColor or self.borderColor)
		love.graphics.rectangle("line", inputX, y, self.w - 100, fieldHeight)

		love.graphics.setColor(self.color)
		love.graphics.print(field.value, inputX + 4, y + 2)

		if i == self.activeFieldIndex and self.cursorTimer > 0.5 then
			local textW = self.font:getWidth(field.value)
			love.graphics.line(
				inputX + 4 + textW + 1,
				y + 2,
				inputX + 4 + textW + 1,
				y + fieldHeight - 2
			)
		end
	end
end

return Form
