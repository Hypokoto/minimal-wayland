#!/usr/bin/env bash
# Brightness OSD via Mako

set -euo pipefail
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down>"
    exit 1
fi
ACTION=$1

if [ "$ACTION" = "up" ]; then
    brightnessctl set +5% >/dev/null 2>&1 || true
elif [ "$ACTION" = "down" ]; then
    brightnessctl set 5%- >/dev/null 2>&1 || true
fi

# Get current brightness portably without PCRE dependency
BRIGHTNESS=$(brightnessctl info 2>/dev/null | grep -o '[0-9]\+%' | head -1 | tr -d '%' || echo "0")

notify-send -r 91111 -t 1500 -a "OSD" "Brightness: ${BRIGHTNESS}%"
