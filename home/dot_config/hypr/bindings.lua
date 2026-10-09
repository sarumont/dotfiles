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

-- Layout: scrolling everywhere (niri/OmniWM-style), set in looknfeel.lua.
-- Drop Omarchy's per-workspace dwindle/scrolling toggle.
hl.unbind("SUPER + L")
o.bind("SUPER + R", "Cycle column width", hl.dsp.layout("colresize +conf"))

-- Vim-style horizontal navigation (the scrolling axis): H/L focus like
-- SUPER+LEFT/RIGHT; SHIFT moves the whole column (swapcol wraps at the ends).
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + SHIFT + H", "Move column left", hl.dsp.layout("swapcol l"))
o.bind("SUPER + SHIFT + L", "Move column right", hl.dsp.layout("swapcol r"))

-- Close window moves to SUPER+Q (was SUPER+W, now the www workspace).
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Workspaces: 1-4 general purpose, 5-10 removed, plus named workspaces on
-- their first letter (comms is on I: SUPER+C is Omarchy's universal copy).
-- One scheme for all of them:
--   SUPER + <key>              go to workspace
--   SUPER + ALT + <key>        move window there (and follow)
--   SUPER + SHIFT + ALT + <key> move window there silently
-- (SUPER+SHIFT+<letter> is Omarchy's app launchers, hence ALT for moves.)
-- Omarchy binds number keys by keycode (code:10 = 1 ... code:19 = 10).
for workspace = 5, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end

-- SUPER+ALT+1-5 was "switch to group window N": move it to SUPER+CTRL+ALT.
for index = 1, 5 do
  local key = "code:" .. tostring(index + 9)
  hl.unbind("SUPER + ALT + " .. key)
  o.bind("SUPER + CTRL + ALT + " .. key, "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
end

-- Numbered 1-4: move on SUPER+ALT instead of Omarchy's SUPER+SHIFT
-- (silent move stays on Omarchy's SUPER+SHIFT+ALT).
for workspace = 1, 4 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + SHIFT + " .. key)
  o.bind("SUPER + ALT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end

-- Music: the cliamp TUI takes over SUPER+SHIFT+M (was Spotify), freeing
-- SUPER+SHIFT+ALT+M (its old key) for the silent move below.
hl.unbind("SUPER + SHIFT + ALT + M")
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", { tui = "cliamp", focus = true })

local named_workspaces = { D = "dev", W = "www", I = "comms", M = "music", N = "notes" }
for key, name in pairs(named_workspaces) do
  local workspace = "name:" .. name
  o.bind("SUPER + " .. key, "Switch to workspace " .. name, hl.dsp.focus({ workspace = workspace }))
  o.bind("SUPER + ALT + " .. key, "Move window to workspace " .. name, hl.dsp.window.move({ workspace = workspace }))
  o.bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. name, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

-- Apps that open on their workspace (Firefox's screen-sharing indicator keeps
-- Omarchy's rule, which hides it).
o.window({ class = "^firefox$", title = "negative:.*is sharing.*" }, { workspace = "name:www" })
o.window("^(obsidian|md\\.obsidian\\.Obsidian)$", { workspace = "name:notes" })
-- Discord is an Omarchy web app (Chromium --app: class chrome-<host>__<path>-Default);
-- Signal is the native signal-desktop.
o.window("^(chrome-discord\\.com__.*|[Ss]ignal|signal-desktop)$", { workspace = "name:comms" })
o.window("^org\\.omarchy\\.cliamp$", { workspace = "name:music" })

-- Calendar: Google Calendar instead of HEY.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com" })
