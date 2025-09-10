COVER_PATH="/tmp/music_cover.jpg"
MAX_LABEL_LENGTH=28

echo "$SENDER" >> /tmp/music.log

next() {
  osascript -e 'tell application "Music" to next track'
  update
}

back () {
  osascript -e 'tell application "Music" to play previous track'
  update
}

pause () {
  osascript -e 'tell application "Music" to playpause'
  update
}

truncate_text() {
  local text="$1"
  local max_length=${2:-$MAX_LABEL_LENGTH}
  if [ ${#text} -le "$max_length" ]; then
    echo "$text"
  else
    echo "${text:0:max_length}" | sed -E 's/\s+[[:alnum:]]*$//' | awk '{$1=$1};1' | sed 's/$/.../'
  fi
}

update() {
  local state
  state=$(osascript -e 'tell application "Music" to get player state' 2>/dev/null)

  # Close if not playing
  if [ "$state" != "playing" ] && [ "$state" != "paused" ]; then
    sketchybar -m --set apple popup.drawing=off
    exit 0
  fi

  # Save album cover
  /bin/bash "$HOME/.config/sketchybar/plugins/save_cover.sh"

  sketchybar -m --set music.cover background.image="$COVER_PATH"

  # Set play or pause icon depending on state
  local play_icon=""
  if [ "$state" = "playing" ]; then
    play_icon="􀊆"  # pause icon
  else
    play_icon="􀊄"  # play icon
  fi

  # Get song info
  local track artist album
  track=$(osascript -e 'tell application "Music" to get name of current track')
  artist=$(osascript -e 'tell application "Music" to get artist of current track')
  album=$(osascript -e 'tell application "Music" to get album of current track')

  track=$(truncate_text "$track" $((MAX_LABEL_LENGTH * 8/10)))
  artist=$(truncate_text "$artist")
  album=$(truncate_text "$album")

  sketchybar -m --set music.pause icon="$play_icon" \
                --set music.title label="$track" \
                --set music.artist label="$artist" \
                --set music.album label="$album" \
                --set apple.popup.drawing=on
}

popup() {
  sketchybar -m --set apple popup.drawing=$1
}

mouse_clicked () {
  case "$NAME" in
    "music.next") next
    ;;
    "music.back") back
    ;;
    "music.pause") pause
    ;;
    *) exit
    ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") 
    popup on
    update
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  "routine") update
  ;;
  "forced") exit 0
  ;;
  *) update
  ;;
esac

