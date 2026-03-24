#!/bin/bash

source "$CONFIG_DIR/icons.sh"

source "$CONFIG_DIR/colors.sh"

wifi=(
  padding_right=7
  icon="$WIFI_DISCONNECTED"
  icon.color=$BLUE
  label.width=0
  label.color=$WHITE
  script="$PLUGIN_DIR/wifi.sh"
  update_freq=30
  updates=on
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi wifi_change mouse.clicked
