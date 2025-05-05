local Track = {}
Track.__index = Track

function Track.new(settings)
	local instance = setmetatable({}, Track)

	local scrollBar = settings.scrollBar or {}
	local track = scrollBar.track or {}
	instance.image = track.image or nil
	instance.color = track.color or { 0.2, 0.2, 0.2, 0.3 }
	instance.showScrollTrack = (track.showScrollTrack == nil) and true or track.showScrollTrack

	return instance
end

function Track:draw(x, y, w, h)
	if self.showScrollTrack then
		if self.image then
			love.graphics.draw(self.image, x, y)
		else
			love.graphics.setColor(self.color)
			love.graphics.rectangle("fill", x, y, w, h)
		end
	end
end

return Track
