#!/bin/sh
# minimal battery — vague colors, no external deps

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

GREEN=0xff7fa563
CYAN=0xffb4d4cf
YELLOW=0xfff3be7c
ORANGE=0xffe0a363
RED=0xffd8647e

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="" COLOR=$GREEN ;;
  [6-8][0-9]) ICON="" COLOR=$CYAN ;;
  [3-5][0-9]) ICON="" COLOR=$YELLOW ;;
  [1-2][0-9]) ICON="" COLOR=$ORANGE ;;
  *) ICON="" COLOR=$RED ;;
esac

if [ -n "$CHARGING" ]; then
  # U+26A1 + U+FE0E forces text (non-emoji) presentation — portable octal, no encoding issues
  ICON=$(printf '􀋦')
  COLOR=$GREEN
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%" label.color="$COLOR"
