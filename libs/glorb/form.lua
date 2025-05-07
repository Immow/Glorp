local Form = {}
Form.__index = Form

function Form.new(settings)
	local instance             = setmetatable({}, Form)

	instance.text              = settings.text or ""
	instance.font              = settings.font or love.graphics.getFont()
	instance.color             = settings.color or { 1, 1, 1, 1 }
	instance.x                 = settings.x or 0
	instance.y                 = settings.y or 0
	instance.w                 = settings.w or 200
	instance.h                 = settings.h or instance.font:getHeight() + 4
	instance.offset            = 4
	instance.clickedInForm     = false
	instance.limit             = settings.limit or nil
	instance.masked            = settings.masked or false

	instance.backgroundColor   = settings.backgroundColor or { 0, 0, 0, 0.2 }
	instance.borderColor       = settings.borderColor or { 0.7, 0.7, 0.7, 1 }
	instance.activeBorderColor = settings.activeBorderColor or { 1, 1, 1, 1 }

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
	if self.clickedInForm then
		local textToAdd = t
		if self.limit then
			if #self.text + #t > self.limit then
				textToAdd = t:sub(1, self.limit - #self.text)
			end
		end
		if self.font:getWidth(self.text .. textToAdd) < self.w - 8 then
			self.text = self.text .. textToAdd
		end
	end
end

function Form:keypressed(key)
	if self.clickedInForm then
		if key == "backspace" then
			self.text = self.text:sub(1, -2)
		elseif key == "return" or key == "kpenter" then
			self.clickedInForm = false
		end
	end
end

function Form:mousepressed(mx, my, mouseButton)
	if mouseButton ~= 1 then return end
	self.clickedInForm = mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h
end

function Form:draw()
	-- Background
	love.graphics.setColor(self.backgroundColor)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	-- Border
	love.graphics.setColor(self.clickedInForm and self.activeBorderColor or self.borderColor)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	-- Text
	love.graphics.setColor(self.color)
	local displayText = self.masked and string.rep("*", #self.text) or self.text
	love.graphics.print(displayText, self.x + self.offset, self.y + 2)

	-- Cursor
	if self.clickedInForm and self.cursorTimer > 0.5 then
		local textW = self.font:getWidth(displayText)
		love.graphics.line(
			self.x + self.offset + textW + 1,
			self.y + 2,
			self.x + self.offset + textW + 1,
			self.y + self.h - 2
		)
	end
end

return Form
