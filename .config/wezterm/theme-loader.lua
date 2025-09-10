-- ~/.config/wezterm/theme-loader.lua
local function parse_theme(path)
  local theme = {}
  local file = io.open(path, "r")
  if not file then
    error("Could not open theme file: " .. path)
  end

  for line in file:lines() do
    -- Match keys with underscores/dashes and hex values (with or without #)
    local key, value = line:match("^([%w%-%_]+):%s*\"?#?([%x]+)\"?")
    if key and value then
      if not value:match("^#") then
        value = "#" .. value
      end
      -- Normalize key: replace dashes with underscores for Lua
      key = key:gsub("%-", "_")
      theme[key] = value
    end
  end
  file:close()
  return theme
end

local function load_theme()
  local theme_file = os.getenv("HOME") .. "/.config/theme-current.yml"
  local t = parse_theme(theme_file)

  return {
    foreground = t.foreground,
    background = t.background,
    cursor_bg = t.accent or t.foreground,
    cursor_border = t.accent or t.foreground,
    cursor_fg = t.background,
    selection_bg = t.accent or t.bright_blue,
    selection_fg = t.background,
    ansi = {
      t.black, t.red, t.green, t.yellow,
      t.blue, t.magenta, t.cyan, t.white,
    },
    brights = {
      t.bright_black, t.bright_red, t.bright_green, t.bright_yellow,
      t.bright_blue, t.bright_magenta, t.bright_cyan, t.bright_white,
    },
  }
end

return { colors = load_theme() }
