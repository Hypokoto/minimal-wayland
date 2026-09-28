#!/usr/bin/env bash
# Brightness OSD via Mako

set -euo pipefail
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down>"
    exit 1
fi
ACTION=$1

if command -v minosd >/dev/null 2>&1; then
    case "$ACTION" in
        up)   minosd B+10; exit 0 ;;
        down) minosd B-10; exit 0 ;;
    esac
fi

if [ "$ACTION" = "up" ]; then
    brightnessctl set +5% >/dev/null 2>&1 || true
elif [ "$ACTION" = "down" ]; then
    brightnessctl set 5%- >/dev/null 2>&1 || true
fi

# Get current brightness using fast machine-readable format
RAW=$(brightnessctl -m 2>/dev/null || echo "")
if [ -n "$RAW" ]; then
    IFS=',' read -r _ _ _ BRIGHTNESS _ <<< "$RAW"
    BRIGHTNESS="${BRIGHTNESS%\%}"
else
    BRIGHTNESS="0"
fi

notify-send -r 91111 -t 1500 -a "OSD" "Brightness: ${BRIGHTNESS:-0}%"
