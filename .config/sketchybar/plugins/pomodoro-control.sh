#!/bin/bash
# pomodoro controller — called by sketchybar click + Raycast scripts
# usage: pomodoro-control.sh {start|toggle|reset|break} [minutes]
#   start [mins]  — start focus (default 25, or FOCUS_LEN)
#   toggle        — idle->focus, focus<->paused-focus, break<->paused-break
#   reset         — back to idle
#   break [mins]  — start break now (default 5, or BREAK_LEN)

STATE_FILE="$HOME/.config/sketchybar/.pomodoro"
ENGINE="$HOME/.config/sketchybar/plugins/pomodoro.sh"

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
CMD="${1:-toggle}"

save() { # $1 status, $2 end, $3 remaining
  cat > "$STATE_FILE" <<EOF
STATUS=$1
END=$2
REMAINING=$3
FOCUS_LEN=$FOCUS_LEN
BREAK_LEN=$BREAK_LEN
EOF
}

case "$CMD" in
  start)
    MINS="${2:-$((FOCUS_LEN / 60))}"
    SECS=$((MINS * 60))
    FOCUS_LEN=$SECS
    save focus $((NOW + SECS)) "$SECS"
    ;;
  break)
    MINS="${2:-$((BREAK_LEN / 60))}"
    SECS=$((MINS * 60))
    BREAK_LEN=$SECS
    save break $((NOW + SECS)) "$SECS"
    ;;
  reset|stop|clear)
    save idle 0 "$FOCUS_LEN"
    ;;
  toggle|*)
    case "$STATUS" in
      idle)
        save focus $((NOW + FOCUS_LEN)) "$FOCUS_LEN"
        ;;
      focus)
        LEFT=$((END - NOW))
        [ "$LEFT" -lt 0 ] && LEFT=0
        save paused-focus "$END" "$LEFT"
        ;;
      paused-focus)
        save focus $((NOW + REMAINING)) "$REMAINING"
        ;;
      break)
        LEFT=$((END - NOW))
        [ "$LEFT" -lt 0 ] && LEFT=0
        save paused-break "$END" "$LEFT"
        ;;
      paused-break)
        save break $((NOW + REMAINING)) "$REMAINING"
        ;;
    esac
    ;;
esac

# refresh bar immediately (engine also ticks every 1s)
NAME=pomodoro bash "$ENGINE" >/dev/null 2>&1 &
