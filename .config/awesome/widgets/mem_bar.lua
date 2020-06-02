local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = beautiful.mem_bar_active_color or "#5AA3CC"
local background_color = beautiful.mem_bar_background_color or "#222222"

local mem_bar = wibox.widget{
    max_value     = 1,
    value         = .5,
    forced_height = dpi(10),
    margins       = {
        top = dpi(8),
        bottom = dpi(8),
    },
    forced_width  = dpi(100),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    color         = active_color,
    background_color = background_color,
    border_width  = 0,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
}
local mem_icon = wibox.widget.imagebox(icons.mem)


local mem_box = wibox.widget{
    mem_icon,
    mem_bar,
    layout = wibox.layout.fixed.horizontal
}

return {
    bar = mem_bar,
    widget = mem_box
}
