#!/bin/bash

source "$CONFIG_DIR/colors.sh"

disk=(
  icon=󰋊
  icon.color=$BLUE
  icon.font="BerkeleyMono Nerd Font:Bold:14.0"
  label.color=$WHITE
  update_freq=60
  script="$PLUGIN_DIR/disk.sh"
  updates=on
)

sketchybar --add item disk right \
           --set disk "${disk[@]}"
