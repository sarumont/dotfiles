local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local vicious       = require("vicious")
local awful         = require("awful")
local rounded_bar   = require("widgets.rounded_bar")
local spr = wibox.widget.textbox(' ')

require("evil.volume")
require("evil.weather")

local mpd_icon = wibox.widget.imagebox(icons.music)
local mpd = wibox.widget.textbox()
local paused_color = beautiful.mpd_song_paused_color or beautiful.fg_normal
local title_color =  beautiful.mpd_song_title_color or beautiful.fg_focus
local artist_color = beautiful.mpd_song_artist_color or beautiful.fg_focus
vicious.register(
    mpd,
    vicious.widgets.mpd,
    function (widget, args)
        local state = args["{state}"]
        if state == "Stop" or state == "Pause" then
            artist_fg = paused_color
            title_fg = paused_color
        else
            artist_fg = artist_color
            title_fg = title_color
        end
        return ('<span foreground=\'%s\'>%s - </span><span foreground=\'%s\'>%s</span>'):format(
            artist_fg, args["{Artist}"], title_fg, args["{Title}"])
    end,
    8)

local cpu = rounded_bar(beautiful.cpu_bar_active_color, beautiful.cpu_bar_background_color, icons.cpu)
vicious.register(cpu.bar, vicious.widgets.cpu, "$1", 3)
local mem = rounded_bar(beautiful.mem_bar_active_color, beautiful.mem_bar_background_color, icons.mem)
vicious.register(mem.bar, vicious.widgets.mem, "$1", 13)

local active_color = beautiful.volume_bar_active_color
local muted_color = beautiful.volume_bar_muted_color
local active_background_color = beautiful.volume_bar_active_background_color
local muted_background_color = beautiful.volume_bar_muted_background_color
local volume_bar = rounded_bar(beautiful.volume_bar_active_color, beautiful.volume_bar_background_color, icons.volume)
awesome.connect_signal("evil::volume", function(volume, muted)
    local bg_color
    if muted then
        fill_color = muted_color
        bg_color = muted_background_color
        volume_bar.icon.image = icons.muted
    else
        fill_color = active_color
        bg_color = active_background_color
        volume_bar.icon.image = icons.volume
    end
    volume_bar.bar.value = volume / 100
    volume_bar.bar.color = fill_color
    volume_bar.bar.background_color = bg_color
end)

local weather = require("widgets.weather")
local clock_icon = wibox.widget.imagebox(icons.clock)
local clock = wibox.widget.textbox()
vicious.register(
    clock,
    vicious.widgets.date,
    '<span color=\''..beautiful.fg_focus..'\'>%a %d %b %R</span>',
    34)

-- wibox
return function(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ 
            position = "top",
            screen = s,
            height = dpi(24),
            bg = beautiful.wibar_bg,
            fg = beautiful.wibar_fg,
        })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            s.mytaglist,
            spr,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- wibox.widget.systray(),
            mpd_icon,
            mpd,
            spr,
            cpu.widget,
            spr,
            mem.widget,
            spr,
            volume_bar.widget,
            spr,
            weather,
            spr,
            clock_icon,
            clock,
            wibox.container.background(s.mylayoutbox, beautiful.wibar_bg),
        },
    }
end
