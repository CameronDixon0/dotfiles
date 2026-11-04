#!/bin/bash

THEME_DIR="/Users/camerondixon/.config/themes"
WALLPAPER_DIR="/Users/camerondixon/.config/wallpapers"

setwall() {
  local WALLPAPER="$1"

  if [ -z "$WALLPAPER" ]; then
    echo "Usage: setwall /path/to/wallpaper.jpg" >&2
    return 1
  fi

  if [ ! -f "$WALLPAPER" ]; then
    echo "Error: File not found: $WALLPAPER" >&2
    return 1
  fi

  # Resolve to absolute path
  local ABS_PATH="$(cd "$(dirname "$WALLPAPER")"; pwd)/$(basename "$WALLPAPER")"

  local COUNT
  COUNT=$(osascript <<EOF 2>&1
tell application "System Events"
    set numSpaces to count of desktops
    repeat with d in desktops
        set picture of d to POSIX file "$ABS_PATH"
    end repeat
    return numSpaces
end tell
EOF
)

  echo "✅ Wallpaper applied to $COUNT space(s) across all displays."
}

case "$1" in
  "Catppuccin")
    echo "Switching to Catppuccin!"
    cp $THEME_DIR/catppuccin/* $THEME_DIR/current
    desktoppr $WALLPAPER_DIR/catppuccin1.jpeg
    # spicetify config current_theme catppuccin
    # spicetify config color_scheme frappe
    # spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
    # spicetify apply
    ;;
  "Gruvbox")
    echo "Switching to Gruvbox!"
    cp $THEME_DIR/gruvbox/* $THEME_DIR/current
    desktoppr $WALLPAPER_DIR/gruvbox1.jpeg
    # spicetify config current_theme Gruvify
    # spicetify apply
    ;;
  "Ayu")
    echo "Switching to Ayu!"
    cp $THEME_DIR/ayu/* $THEME_DIR/current
    ;;
  "Vague")
    echo "Switching to Vague!"
    cp $THEME_DIR/vague/* $THEME_DIR/current
    ;;
  *)
    echo "Invalid theme"
    exit
    ;;
esac

/opt/homebrew/bin/sketchybar --reload
/opt/homebrew/bin/brew services restart borders
touch $HOME/.wezterm.lua
