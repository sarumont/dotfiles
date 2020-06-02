local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = beautiful.cpu_bar_active_color or "#5AA3CC"
local background_color = beautiful.cpu_bar_background_color or "#222222"

local cpu_icon = wibox.widget.imagebox(icons.cpu)
local cpu_bar = wibox.widget{
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

local cpu_box = wibox.widget{
    cpu_icon,
    cpu_bar,
    layout = wibox.layout.fixed.horizontal,
}

return {
    bar = cpu_bar,
    widget = cpu_box,
}
