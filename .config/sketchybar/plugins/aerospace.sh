#!/bin/bash
# minimal aerospace workspace indicator — vague colors
# triggered by custom event: aerospace_workspace_change
# requires in aerospace.toml:
#   exec-on-workspace-change = ['/bin/bash', '-c', 'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE']

GREY=0xff606079    # empty
BLUE=0xff6e94b2    # occupied
FOCUSED_COLOR=0xffcdcdcd  # focused — white to stand out

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# one query for all windows: "ws app" per line
WINDOWS=$(aerospace list-windows --all --format '%{workspace} ' 2>/dev/null)

for sid in 1 2 3 4 5 6 7 m s; do
  if [ "$sid" = "$FOCUSED" ]; then
    sketchybar --set "space.$sid" label.color=$FOCUSED_COLOR
  elif echo "$WINDOWS" | grep -qw "$sid"; then
    sketchybar --set "space.$sid" label.color=$BLUE
  else
    sketchybar --set "space.$sid" label.color=$GREY
  fi
done
