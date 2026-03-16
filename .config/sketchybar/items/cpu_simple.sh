#!/bin/bash

cpu=(
  icon="󰻠"
  icon.font="$FONT:Bold:20.0"
  label.font="$FONT:Semibold:15.0"
  update_freq=5
  script="$PLUGIN_DIR/cpu_simple.sh"
  updates=on
)

sketchybar --add item cpu_simple right \
           --set cpu_simple "${cpu[@]}"
