local wezterm = require 'wezterm'
local mux = wezterm.mux
local home = os.getenv("HOME")
local settings = dofile(home .. "/.config/themes/current/luacolors.lua")

local config = {
  -- Appearance
  --color_scheme = "Catppuccin Macchiato",
  color_scheme = settings.scheme,
  macos_window_background_blur = 30,
  window_background_opacity = 0.75,
  text_background_opacity = 0.6,

  -- Font
  font = wezterm.font 'JetBrains Mono',
  font_size = 18.0,

  -- Padding for 5px gap around all edges
  window_padding = {left = 0, right = 0, top = 0, bottom = 0},

  -- Visuals
  window_decorations = "RESIZE",
  use_fancy_tab_bar = false,
  enable_tab_bar = false,

  leader = {key = 'a', mods = "CTRL", timeout_milliseconds = 1000},
  keys = {
    {key = 'L', mods = "LEADER", action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"} },
    {key = 'J', mods = "LEADER", action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"} },
    {key = 'x', mods = "LEADER", action = wezterm.action.CloseCurrentPane {confirm = true} },
    {key = 'l', mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Right' },
    {key = 'k', mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Up' },
    {key = 'j', mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Down' },
    {key = 'h', mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Left' },
  },

  default_cursor_style = "SteadyBar",
}

wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local gap = 25
  local width, height = screen.width - 2 * gap, screen.height - 2 * gap
  local tab, pane, window = wezterm.mux.spawn_window {}
  --window:gui_window():maximize();
  --pane:send_text('clear\n')
end)

return config
