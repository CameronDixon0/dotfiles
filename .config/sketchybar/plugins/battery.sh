#!/bin/sh

source "$HOME/.config/themes/current/shellcolors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨" COLOR=$BATTERY_FULL
  ;;
  [6-8][0-9]) ICON="􀺸" COLOR=$BATTERY_HIGH
  ;;
  [3-5][0-9]) ICON="􀺶" COLOR=$BATTERY_MID
  ;;
  [1-2][0-9]) ICON="􀛩" COLOR=$BATTERY_LOW
  ;;
  *) ICON="􀛪" COLOR=$BATTERY_EMPTY
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR" padding_right=10
