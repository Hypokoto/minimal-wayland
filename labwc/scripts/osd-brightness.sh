#!/usr/bin/env bash
# Brightness OSD via Mako

set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

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

RAW=$(brightnessctl -m 2>/dev/null || true)
if [ -z "$RAW" ]; then
    exit 0
fi

IFS=',' read -r _ _ _ BRIGHTNESS _ <<< "$RAW"
BRIGHTNESS="${BRIGHTNESS%\%}"

if command -v minosd >/dev/null 2>&1 && minosd B "${BRIGHTNESS:-0}" 2>/dev/null; then
    exit 0
fi

notify-send -r 91111 -h string:x-canonical-private-synchronous:brightness -t 1500 -a "OSD" "Brightness: ${BRIGHTNESS:-0}%"
