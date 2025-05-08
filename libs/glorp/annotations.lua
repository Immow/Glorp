---@meta

---@class Glorp.containerSettings
---@field id? any
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field layout? "horizontal"|"vertical"
---@field spacing? number
---@field label? string
---@field border? boolean
---@field borderColor? table
---@field backgroundColor? table
---@field scrollable? boolean
---@field scrollDirection? "horizontal"|"vertical"
---@field showScrollbar? boolean
---@field alignment? { horizontal: "left"|"center"|"right", vertical: "top"|"center"|"bottom"}
---@field bar?  { x: number, y: number, w: number ,h: number ,color: table }

---@class Glorp.Container
---@field addButton? fun(self: Glorp.Container, settings: Glorp.ButtonSettings): Glorp.Container
---@field addImage? fun(self: Glorp.Container, settings: Glorp.ImageSettings): Glorp.Container
---@field addButtonList? fun(self: Glorp.Container, settings: Glorp.ButtonListSettings): Glorp.Container
---@field addText? fun(self: Glorp.Container, settings: Glorp.TextSettings): Glorp.Container
---@field addContainer? fun(self: Glorp.Container, settings: Glorp.Container): Glorp.Container
---@field addDropDown? fun(self: Glorp.Container, settings: Glorp.DropDownSettings): Glorp.Container
---@field addForm? fun(self: Glorp.Container, settings: Glorp.FormSettings): Glorp.Container
---@field addSlider? fun(self: Glorp.Container, settings: Glorp.SliderSettings): Glorp.Container

---@class Glorp.ButtonSettings
---@field id? any
---@field w? number
---@field h? number
---@field label? string
---@field layout? "horizontal"|"vertical"
---@field alignment? { horizontal: "left"|"center"|"right", vertical: "top"|"center"|"bottom"}
---@field font? string
---@field fn? function

---@class Glorp.SliderSettings
---@field id? any
---@field w? number
---@field h? number
---@field fn? function


-- instance.startValue       = settings.startValue or 0
-- instance.groove_h         = settings.groove_h or 8
-- instance.knob_w           = settings.knob_w or 20
-- instance.knob_h           = settings.knob_h or 20
-- instance.knob_x           = instance.x + (instance.w - instance.knob_w) * instance.startValue
-- instance.start_x          = settings.x or 0
-- instance.start_y          = settings.y or 0
-- instance.sliderRangeMax   = settings.sliderRangeMax or 1
-- instance.sliderRangeMin   = settings.sliderRangeMin or 0
-- instance.active           = false
-- instance.parentDimensions = {}
-- instance.grooveColor      = settings.grooveColor or { 0.3, 0.3, 0.3 }
-- instance.knobColor        = settings.knobColor or { 1, 1, 1 }
-- instance.knobBorderColor  = settings.knobBorderColor or { 0, 0, 0 }


---@class Glorp.ButtonListSettings
---@field id? any
---@field w? number
---@field h? number
---@field label? string
---@field layout? "horizontal"|"vertical"
---@field alignment? { horizontal: "left"|"center"|"right", vertical: "top"|"center"|"bottom"}
---@field font? string
---@field fn? function

---@class Glorp.TextSettings
---@field w? number
---@field h? number
---@field color? table
---@field text? string
---@field align? "left"|"center"|"right"
---@field font? string

---@class Glorp.ImageSettings
---@field label? string
---@field image? love.Image
---@field w? number
---@field h? number

---@class Glorp.FormSettings
---@field label? string
---@field image? love.Image
---@field w? number
---@field h? number

---@class Glorp.DropDownSettings
---@field w? number
---@field h? number
---@field bgColor? table
---@field hoverColor? table
---@field textColor? table
---@field text? string
---@field align? "left"|"center"|"right"
---@field font? string
---@field options? table
