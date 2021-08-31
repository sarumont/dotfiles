local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local lain          = require("lain")
local user = require("user")

local scrlocker    = "slock"
local modkey       = "Mod4"
local altkey       = "Mod1"

local keys = {}

local quake = lain.util.quake({
    app = user.terminal,
    name = "visor",
    argname = "--name visor",
    extra = "-e \"" .. os.getenv("HOME") .. "/.my/bin/tmux_attach main\"",
    horiz = "center",
    height = .75,
    width = .99,
    followtag = true
  })

keys.globalkeys = gears.table.join(
  -- Take a screenshot
  -- https://github.com/lcpz/dots/blob/master/bin/screenshot
  awful.key({ modkey, "Shift" }, "3", function()
    stamp = os.date("%Y-%m-%d-%H%M%S")
    os.execute("maim ~/Screenshot\\ " .. stamp .. ".png")
  end,
            {description = "take a screenshot", group = "hotkeys"}),
  awful.key({ modkey, "Shift" }, "4", function() 
    stamp = os.date("%Y-%m-%d-%H%M%S")
    os.execute("maim -s ~/Screenshot\\ " .. stamp .. ".png")
  end,
            {description = "take a selective screenshot", group = "hotkeys"}),

  -- X screen locker
  awful.key({ modkey, "Shift" }, "l", function () os.execute(scrlocker) end,
            {description = "lock screen", group = "hotkeys"}),

  -- Hotkeys
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
            {description = "show help", group = "awesome"}),
  -- Tag browsing
  awful.key({ "Control", "Shift" }, "h",   awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ "Control", "Shift" }, "l",   awful.tag.viewnext, { description = "view next", group = "tag" }),

  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),

  -- By direction client focus
  awful.key({ altkey }, "j",
      function()
          awful.client.focus.global_bydirection("down")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus down", group = "client"}),
  awful.key({ altkey }, "k",
      function()
          awful.client.focus.global_bydirection("up")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus up", group = "client"}),
  awful.key({ altkey }, "h",
      function()
          awful.client.focus.global_bydirection("left")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus left", group = "client"}),
  awful.key({ altkey }, "l",
      function()
          awful.client.focus.global_bydirection("right")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus right", group = "client"}),
  awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end,
      {description = "go back", group = "client"}),

  -- Show/Hide Wibox
  awful.key({ modkey }, "b", function ()
          for s in screen do
              s.mywibox.visible = not s.mywibox.visible
              if s.mybottomwibox then
                  s.mybottomwibox.visible = not s.mybottomwibox.visible
              end
          end
      end,
      {description = "toggle wibox", group = "awesome"}),

  -- Dynamic tagging
  awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
            {description = "add new tag", group = "tag"}),
  awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
            {description = "rename tag", group = "tag"}),
  awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
            {description = "move tag to the left", group = "tag"}),
  awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
            {description = "move tag to the right", group = "tag"}),
  awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
            {description = "delete tag", group = "tag"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(user.terminal) end,
            {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"}),

  -- Dropdown application
  awful.key({ "Control", "Shift", }, "Return", function () quake:toggle() end,
            {description = "visor", group = "launcher"}),

  -- Widgets popups
  awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
            {description = "show calendar", group = "widgets"}),
  awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
            {description = "show weather", group = "widgets"}),

  -- Brightness
  awful.key({ }, "XF86MonBrightnessUp", function () 
      local f = assert(io.popen("light -A 5", 'r'))
  end,
  {description = "+5%", group = "hotkeys"}),
  awful.key({ }, "XF86MonBrightnessDown", function () 
      local f = assert(io.popen("light -U 5", 'r'))
  end,
            {description = "-5%", group = "hotkeys"}),

  -- PulseAudio volume control
  awful.key({modkey, "Control"}, "Up",
      function ()
          os.execute("pactl set-sink-volume 0 +5%")
      end,
      {description = "volume up", group = "hotkeys"}),
  awful.key({modkey, "Control"}, "Down",
      function ()
          os.execute("pactl set-sink-volume 0 -5%")
      end,
      {description = "volume down", group = "hotkeys"}),
  awful.key({ }, "XF86AudioRaiseVolume",
      function ()
          os.execute("pactl set-sink-volume 0 +5%")
      end,
      {description = "volume up", group = "hotkeys"}),
  awful.key({ }, "XF86AudioLowerVolume",
      function ()
          os.execute("pactl set-sink-volume 0 -5%")
      end,
      {description = "volume down", group = "hotkeys"}),
  awful.key({ }, "XF86AudioMute",
      function ()
          os.execute("pactl set-sink-mute 0 toggle")
      end,
      {description = "toggle mute", group = "hotkeys"}),
  awful.key({ }, "XF86AudioMicMute",
      function ()
          os.execute("pactl set-source-mute 0 toggle")
      end,
      {description = "toggle mute", group = "hotkeys"}),

  -- MPD control
  awful.key({ }, "XF86AudioPlay",
      function ()
          os.execute("playerctl play-pause")
      end,
      {description = "toggle play/pause", group = "music"}),
  awful.key({ altkey, "Control" }, "Up",
      function ()
          os.execute("playerctl play-pause")
      end,
      {description = "toggle play/pause", group = "music"}),
  awful.key({ altkey, "Control" }, "Down",
      function ()
          os.execute("playerctl stop")
      end,
      {description = "stop the music (why?)", group = "music"}),
  awful.key({ }, "XF86AudioPrev",
      function ()
          os.execute("playerctl previous")
      end,
      {description = "go back", group = "music"}),
  awful.key({ altkey, "Control" }, "Left",
      function ()
          os.execute("playerctl previous")
      end,
      {description = "go back", group = "music"}),
  awful.key({ }, "XF86AudioNext",
      function ()
          os.execute("playerctl next")
      end,
      {description = "next track (go into the future!)", group = "music"}),
  awful.key({ altkey, "Control" }, "Right",
      function ()
          os.execute("playerctl next")
      end,
      {description = "next track (go into the future!)", group = "music"}),

  -- Prompt
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),

  -- launcher / run or raise 
  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"}),

  awful.key({ modkey }, 'e', function () awful.spawn('spacefm') end,
  {description = "Spawn SpaceFM", group = "launcher"}),

  awful.key({ modkey }, 'g', function ()
      local matcher = function (c)
          return awful.rules.match(c, {class = 'Google-chrome'})
      end
      awful.client.run_or_raise(user.chrome or 'google-chrome', matcher)
  end,
  {description = 'Launch Chrome', group = 'launcher'}),

  awful.key({ modkey }, 'h', function ()
      local matcher = function (c)
          return awful.rules.match(c, {instance = 'Navigator'})
      end
      awful.client.run_or_raise(user.browser or 'firefox', matcher)
  end,
  {description = "Launch Browser", group = "launcher"}),

  awful.key({ modkey }, 'l', function ()
    local comms = awful.tag.find_by_name(awful.screen.focused(), "comms")
    if comms then
      comms:view_only()
    end
  end,
  {description = "Switch to comms", group = "launcher"}),

  -- TODO: this is tied to termite
  awful.key({ modkey }, 'd', function ()
    awful.client.run_or_raise("termite --name=dev --exec=\"" .. os.getenv("HOME") .. "/.my/bin/tmux_attach dev\"",
      function (c)
        return awful.rules.match(c, {instance = 'dev'})
      end)
    end,
    {description = "Launch dev terminal", group = "launcher"}),

  -- TODO: these are tied to asusctl. Need to break out a user.keys when I can
  awful.key({ }, "XF86Launch4",
      function ()
          os.execute("asusctl profile -n")
      end,
      {description = "Switch Fan profile", group = "system"}),

  awful.key({ }, "XF86KbdBrightnessDown",
      function ()
          os.execute(os.getenv("HOME") .. "/.local/bin/kbd down")
      end,
      {description = "Decrease Keyboard backlight", group = "system"}),
  awful.key({ }, "XF86KbdBrightnessUp",
      function ()
          os.execute(os.getenv("HOME") .. "/.local/bin/kbd up")
      end,
      {description = "Increase Keyboard backlight", group = "system"})
)

keys.clientkeys = gears.table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)


root.keys(keys.globalkeys)

return keys
