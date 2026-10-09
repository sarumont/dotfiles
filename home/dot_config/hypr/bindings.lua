-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Close window moves to SUPER+Q (was SUPER+W, now the www workspace).
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Workspaces: 1-4 general purpose (Omarchy's bindings), 5-10 removed, plus
-- named workspaces on their first letter. comms is on I: SUPER+C is
-- Omarchy's universal copy. Omarchy binds workspace keys by keycode
-- (code:10 = 1 ... code:19 = 10).
for workspace = 5, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end

local named_workspaces = { D = "dev", W = "www", I = "comms", M = "music", N = "notes" }
for key, name in pairs(named_workspaces) do
  o.bind("SUPER + " .. key, "Switch to workspace " .. name, hl.dsp.focus({ workspace = "name:" .. name }))
  -- SUPER+SHIFT+<key> is taken by Omarchy launchers; SUPER+ALT+<key> is free
  o.bind("SUPER + ALT + " .. key, "Move window to workspace " .. name, hl.dsp.window.move({ workspace = "name:" .. name }))
end

-- Apps that open on their workspace (Firefox's screen-sharing indicator keeps
-- Omarchy's rule, which hides it).
o.window({ class = "^firefox$", title = "negative:.*is sharing.*" }, { workspace = "name:www" })
o.window("^(obsidian|md\\.obsidian\\.Obsidian)$", { workspace = "name:notes" })
-- Discord is an Omarchy web app (Chromium --app: class chrome-<host>__<path>-Default);
-- Signal is the native signal-desktop.
o.window("^(chrome-discord\\.com__.*|[Ss]ignal|signal-desktop)$", { workspace = "name:comms" })

-- Calendar: Google Calendar instead of HEY.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com" })
