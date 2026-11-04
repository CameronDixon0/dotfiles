#!/bin/bash
# pomodoro engine — runs every second via sketchybar update_freq=1
# reads ~/.config/sketchybar/.pomodoro, updates the `pomodoro` item
# vague colors: idle grey, focus white, paused yellow, break blue

STATE_FILE="$HOME/.config/sketchybar/.pomodoro"
NAME="${NAME:-pomodoro}"

# defaults if no state file yet
if [ ! -f "$STATE_FILE" ]; then
  cat > "$STATE_FILE" <<EOF
STATUS=idle
END=0
REMAINING=1500
FOCUS_LEN=1500
BREAK_LEN=300
EOF
fi

# shellcheck disable=SC1090
. "$STATE_FILE"

NOW=$(date +%s)

fmt() {
  # $1 = seconds -> MM:SS
  s=$1
  [ "$s" -lt 0 ] && s=0
  printf "%02d:%02d" $((s / 60)) $((s % 60))
}

# vague
GREY=0xff606079
WHITE=0xffcdcdcd
YELLOW=0xfff3be7c
BLUE=0xff6e94b2

notify() { # $1 title, $2 message, $3 sound
  osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1 &
  afplay "$3" >/dev/null 2>&1 &
}

case "$STATUS" in
  focus)
    LEFT=$((END - NOW))
    if [ "$LEFT" -le 0 ]; then
      # focus finished -> start break
      END=$((NOW + BREAK_LEN))
      STATUS=break
      cat > "$STATE_FILE" <<EOF
STATUS=$STATUS
END=$END
REMAINING=$BREAK_LEN
FOCUS_LEN=$FOCUS_LEN
BREAK_LEN=$BREAK_LEN
EOF
      notify "Pomodoro" "Focus done — break $(fmt "$BREAK_LEN")" "/System/Library/Sounds/Glass.aiff"
      sketchybar --set "$NAME" drawing=on label="􀀀 $(fmt "$BREAK_LEN")" label.color=$BLUE
    else
      sketchybar --set "$NAME" drawing=on label="􀨂 $(fmt "$LEFT")" label.color=$WHITE
    fi
    ;;
  break)
    LEFT=$((END - NOW))
    if [ "$LEFT" -le 0 ]; then
      STATUS=idle
      cat > "$STATE_FILE" <<EOF
STATUS=$STATUS
END=0
REMAINING=$FOCUS_LEN
FOCUS_LEN=$FOCUS_LEN
BREAK_LEN=$BREAK_LEN
EOF
      notify "Pomodoro" "Break over — ready?" "/System/Library/Sounds/Ping.aiff"
      sketchybar --set "$NAME" drawing=off label=""
    else
      sketchybar --set "$NAME" drawing=on label="􁹧 $(fmt "$LEFT")" label.color=$BLUE
    fi
    ;;
  paused-focus|paused-break)
    sketchybar --set "$NAME" drawing=on label="􀊆 $(fmt "$REMAINING")" label.color=$YELLOW
    ;;
  idle|*)
    # idle: show nothing
    sketchybar --set "$NAME" drawing=off label=""
    ;;
esac
