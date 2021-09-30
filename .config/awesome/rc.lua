-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local keys          = require("keys")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- This function implements the XDG autostart specification
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "/etc/xdg/autostart:' .. os.getenv("HOME") .. '/.config/autostart"' -- https://github.com/jceb/dex
)

-- }}}
local user = require("user")

icons = require("icons")
icons.init(user.icon_theme)

-- Initialization
-- ===================================================================
-- Theme handling library
local xrdb = beautiful.xresources.get_current_theme()
-- Make dpi function global
dpi = beautiful.xresources.apply_dpi
-- Make xresources colors global
x = {
    --           xrdb variable      fallback
    background = xrdb.background or "#1D1F28",
    foreground = xrdb.foreground or "#FDFDFD",
    color0     = xrdb.color0     or "#282A36",
    color1     = xrdb.color1     or "#F37F97",
    color2     = xrdb.color2     or "#5ADECD",
    color3     = xrdb.color3     or "#F2A272",
    color4     = xrdb.color4     or "#8897F4",
    color5     = xrdb.color5     or "#C574DD",
    color6     = xrdb.color6     or "#79E6F3",
    color7     = xrdb.color7     or "#FDFDFD",
    color8     = xrdb.color8     or "#414458",
    color9     = xrdb.color9     or "#FF4971",
    color10    = xrdb.color10    or "#18E3C8",
    color11    = xrdb.color11    or "#FF8037",
    color12    = xrdb.color12    or "#556FFF",
    color13    = xrdb.color13    or "#B043D1",
    color14    = xrdb.color14    or "#3FDCEE",
    color15    = xrdb.color15    or "#BEBEC1",
}

-- Themes define colours, icons, fonts, window decorations and wallpapers
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. user.theme .. "/" .. "theme.lua")

-- {{{ Variable definitions

local modkey       = "Mod4"

awful.util.terminal = user.terminal
awful.util.tagnames = { }
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

awful.util.taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

-- }}}

--
-- Wallpaper
-- {{{
local function set_wallpaper(s)
    -- Wallpaper
    if user.wallpaper or beautiful.wallpaper then
        local wallpaper = user.wallpaper or beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set wallpaper
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
end)

-- Tags
awful.screen.connect_for_each_screen(function(s)

    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    awful.tag.add("fl", {
            layout             = awful.layout.suit.floating,
            screen             = s,
            selected           = true,
        })

    awful.tag.add("dev", {
            layout = awful.layout.suit.max,
            screen             = s,
        })

    awful.tag.add("www", {
            layout = (user.layouts and user.layouts.www) or awful.layout.suit.tile,
            master_width_factor = 0.7,
            screen             = s,
        })

    awful.tag.add("comms", {
            layout = (user.layouts and user.layouts.comms) or awful.layout.suit.fair,
            screen             = s,
        })

end)

local wibar = require("wibar")
awful.screen.connect_for_each_screen(function(s)
    wibar(s)
end)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
-- root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

    -- All clients will match this rule.
    { 
        rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false,
            titlebars_enabled = true,
        }
    },

    { rule = { class = "Google-chrome" }, properties = { tag = "www" } },
    { rule = { instance = "Navigator" }, properties = { tag = "www" } },
    { rule = { class = "zoom" }, properties = { ontop = true, floating = true }},
    { rule = { instance = "yubioath-desktop" }, properties = { ontop = true, floating = true }},

    { rule = { instance = "slack" }, properties = { tag = "comms" } },
    { rule = { class = "signal" }, properties = { tag = "comms" } },
    { rule = { class = "discord" }, properties = { tag = "comms" } },

    { 
        rule = { instance = "dev", class = "Termite" },
        properties = { tag = "dev", titlebars_enabled = false }
    },
    { 
        rule = { instance = "visor" }, 
        properties = { titlebars_enabled = false, border_color = beautiful.fg_urgent } 
    },

}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end
    c.shape = gears.shape.rounded_rect
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(16)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

awful.screen.set_auto_dpi_enabled(true)

