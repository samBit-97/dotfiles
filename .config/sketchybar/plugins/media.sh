#!/bin/bash

update_media() {
  STATE="$(echo "$INFO" | jq -r '.state')"

  if [ "$STATE" = "playing" ]; then
    MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
    sketchybar --set media label="$MEDIA" drawing=on \
               --set media_prev drawing=on \
               --set media_play icon="󰏤" drawing=on \
               --set media_next drawing=on
  elif [ "$STATE" = "paused" ]; then
    MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
    sketchybar --set media label="$MEDIA" drawing=on \
               --set media_prev drawing=on \
               --set media_play icon="󰐊" drawing=on \
               --set media_next drawing=on
  else
    sketchybar --set media drawing=off \
               --set media_prev drawing=off \
               --set media_play drawing=off \
               --set media_next drawing=off
  fi
}

poll_media() {
  if pgrep -xq "Spotify"; then
    STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
    if [ "$STATE" = "playing" ]; then
      TITLE=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
      ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
      sketchybar --set media label="$TITLE - $ARTIST" drawing=on \
                 --set media_prev drawing=on \
                 --set media_play icon="󰏤" drawing=on \
                 --set media_next drawing=on
    elif [ "$STATE" = "paused" ]; then
      TITLE=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
      ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
      sketchybar --set media label="$TITLE - $ARTIST" drawing=on \
                 --set media_prev drawing=on \
                 --set media_play icon="󰐊" drawing=on \
                 --set media_next drawing=on
    else
      sketchybar --set media drawing=off \
                 --set media_prev drawing=off \
                 --set media_play drawing=off \
                 --set media_next drawing=off
    fi
  else
    sketchybar --set media drawing=off \
               --set media_prev drawing=off \
               --set media_play drawing=off \
               --set media_next drawing=off
  fi
}

case "$SENDER" in
  "media_change") update_media ;;
  "routine") poll_media ;;
esac
