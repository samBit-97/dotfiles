source "$CONFIG_DIR/colors.sh"

NERD_FONT="BerkeleyMono Nerd Font:Bold:18.0"

# Spotify icon + song name
media=(
  icon=󰓇
  icon.color=$GREEN
  icon.font="$NERD_FONT"
  icon.padding_right=6
  label.max_chars=25
  label.color=$WHITE
  label.font="SF Pro:Semibold:14.0"
  scroll_texts=on
  background.drawing=off
  script="$PLUGIN_DIR/media.sh"
  updates=on
  update_freq=5
)

# Previous track
media_prev=(
  icon=󰒮
  icon.color=$GREY
  icon.font="$NERD_FONT"
  icon.padding_left=8
  label.drawing=off
  background.drawing=off
  click_script="osascript -e 'tell application \"Spotify\" to previous track'"
)

# Play/Pause
media_play=(
  icon=󰏤
  icon.color=$WHITE
  icon.font="$NERD_FONT"
  icon.padding_left=4
  label.drawing=off
  background.drawing=off
  click_script="osascript -e 'tell application \"Spotify\" to playpause'"
)

# Next track
media_next=(
  icon=󰒭
  icon.color=$GREY
  icon.font="$NERD_FONT"
  icon.padding_left=4
  label.drawing=off
  background.drawing=off
  click_script="osascript -e 'tell application \"Spotify\" to next track'"
)

sketchybar --add item media center \
           --set media "${media[@]}" \
           --subscribe media media_change \
           --add item media_prev center \
           --set media_prev "${media_prev[@]}" \
           --subscribe media_prev mouse.clicked \
           --add item media_play center \
           --set media_play "${media_play[@]}" \
           --subscribe media_play mouse.clicked \
           --add item media_next center \
           --set media_next "${media_next[@]}" \
           --subscribe media_next mouse.clicked
