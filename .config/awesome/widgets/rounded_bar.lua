local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local user = require('user')

return function(active_color, background_color, icon)
    local bar = wibox.widget{
        max_value     = 1,
        value         = .5,
        forced_height = dpi(10),
        margins       = {
            top = dpi(8),
            bottom = dpi(8),
        },
        forced_width  = dpi(user.gauge_width or 100),
        shape         = gears.shape.rounded_bar,
        bar_shape     = gears.shape.rounded_bar,
        color         = active_color,
        background_color = background_color,
        border_width  = 0,
        border_color  = beautiful.border_color,
        widget        = wibox.widget.progressbar,
    }

    local imagebox = wibox.widget.imagebox(icon)
    local box = wibox.widget{
        imagebox,
        bar,
        layout = wibox.layout.fixed.horizontal,
    }

    return {
        icon = imagebox,
        bar = bar,
        widget = box,
    }
end
