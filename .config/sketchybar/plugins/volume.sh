#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

M1DDC="/usr/local/bin/m1ddc"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)

  if ! echo "$VOLUME" | grep -qE '^[0-9]+$'; then
    VOLUME=$("$M1DDC" display 1 get volume 2>/dev/null | grep -o '[0-9]\+')
  fi
fi

case "$VOLUME" in
  [6-9][0-9]|100) ICON="􀊨"
  ;;
  [3-5][0-9]) ICON="􀊦"
  ;;
  [1-9]|[1-2][0-9]) ICON="􀊤"
  ;;
  *) ICON="􀊢"
esac

sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" padding_left=10
