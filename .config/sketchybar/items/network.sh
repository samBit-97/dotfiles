#!/bin/bash

network=(
  icon="󰓅"
  icon.font="$FONT:Bold:16.0"
  label.font="$FONT:Semibold:13.0"
  update_freq=3
  script="$PLUGIN_DIR/network.sh"
  updates=on
)

sketchybar --add item network right \
           --set network "${network[@]}"
