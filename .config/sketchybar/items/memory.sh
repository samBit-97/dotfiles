#!/bin/bash

source "$CONFIG_DIR/colors.sh"

memory=(
  icon=󰍛
  icon.color=$GREEN
  icon.font="$FONT:Bold:16.0"
  label.color=$WHITE
  label.font="$FONT:Semibold:13.0"
  background.drawing=off
  script="$PLUGIN_DIR/memory.sh"
  update_freq=10
  updates=on
)

sketchybar --add item memory right \
           --set memory "${memory[@]}"
