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
-- Drop Omarchy's per-workspace dwindle/scrolling toggle and the dwindle-only
-- split toggle (SUPER+J).
hl.unbind("SUPER + L")
hl.unbind("SUPER + J")
o.bind("SUPER + R", "Cycle column width", hl.dsp.layout("colresize +conf"))

-- Keybinding cheat sheets move off K to B ("bindings") to free HJKL. Herdr's
-- stays on SUPER+CTRL+K: SUPER+CTRL+B is Bluetooth.
hl.unbind("SUPER + K")
hl.unbind("SUPER + ALT + K")
o.bind("SUPER + B", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + B", "Tmux keybindings", "omarchy-menu-tmux-keybindings")
-- Compose cheat sheet (picking an entry types it), next to the emoji picker
o.bind("SUPER + CTRL + SHIFT + E", "Compose keys", "compose-keys")

-- Type-to-search window switcher, on OmniWM's palette chord (Control+Option+
-- Space). Replaces Omarchy's background switcher (still in the Omarchy menu).
hl.unbind("SUPER + CTRL + SPACE")
o.bind("SUPER + CTRL + SPACE", "Switch to window", "window-switcher")

-- Vim-style navigation. H/L (the scrolling axis): focus like SUPER+LEFT/RIGHT;
-- SHIFT moves the whole column (swapcol wraps at the ends). J/K (within a
-- stacked column): focus and swap like SUPER(+SHIFT)+DOWN/UP.
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + SHIFT + H", "Move column left", hl.dsp.layout("swapcol l"))
o.bind("SUPER + SHIFT + L", "Move column right", hl.dsp.layout("swapcol r"))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))

-- Stacking (niri-style): join the neighbouring column, or leave the current
-- one if the window is stacked.
o.bind("SUPER + BRACKETLEFT", "Stack into/out of column (left)", hl.dsp.layout("consume_or_expel prev"))
o.bind("SUPER + BRACKETRIGHT", "Stack into/out of column (right)", hl.dsp.layout("consume_or_expel next"))

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

-- Visor (Quake-style drop-down terminal, as in sway/OmniWM): ~/.local/bin/visor
-- toggles the special workspace "visor", launching the terminal on first use.
-- It floats full width, 80% tall, just below the bar (26px reserved at top).
o.bind("CTRL + SHIFT + RETURN", "Visor terminal", "visor")
o.window("^dev\\.sarumont\\.visor$", {
  workspace = "special:visor",
  float = true,
  size = { "(monitor_w)", "(monitor_h*0.8)" },
  move = { 0, 26 },
  -- full width puts the side borders off-screen; drop the border entirely
  border_size = 0,
})

-- Calendar: Google Calendar instead of HEY.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com" })
