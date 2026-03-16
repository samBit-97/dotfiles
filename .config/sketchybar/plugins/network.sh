#!/bin/bash

source "$CONFIG_DIR/colors.sh"

get_bytes() {
  netstat -ib | awk '/en0/ && /Link/ {print $7, $10; exit}'
}

CURRENT=$(get_bytes)
RX_NOW=$(echo "$CURRENT" | awk '{print $1}')
TX_NOW=$(echo "$CURRENT" | awk '{print $2}')

CACHE="$TMPDIR/sketchybar_net"
if [ -f "$CACHE" ]; then
  RX_PREV=$(awk '{print $1}' "$CACHE")
  TX_PREV=$(awk '{print $2}' "$CACHE")

  RX_DIFF=$(( (RX_NOW - RX_PREV) / 3 ))
  TX_DIFF=$(( (TX_NOW - TX_PREV) / 3 ))

  format() {
    local bytes=$1
    if [ "$bytes" -ge 1048576 ]; then
      echo "$(( bytes / 1048576 )) MB/s"
    elif [ "$bytes" -ge 1024 ]; then
      echo "$(( bytes / 1024 )) KB/s"
    else
      echo "${bytes} B/s"
    fi
  }

  UP=$(format "$TX_DIFF")
  DOWN=$(format "$RX_DIFF")

  sketchybar --set network \
    label="↑ $UP  ↓ $DOWN" \
    label.color=$BLUE \
    icon.color=$BLUE
fi

echo "$RX_NOW $TX_NOW" > "$CACHE"
