#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

BDCLI="/usr/local/bin/betterdisplaycli"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)

  # Fallback to BetterDisplay if it's missing or not a number
  if ! echo "$VOLUME" | grep -qE '^[0-9]+$'; then
    VOLUME=$("$BDCLI" get -ddc -value -vcp=audioSpeakerVolume -displayWithMainStatus)
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

sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
