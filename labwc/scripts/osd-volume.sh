#!/usr/bin/env bash
# Volume OSD via Mako

set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute|mic-mute>"
    exit 1
fi
ACTION=$1

case "$ACTION" in
    up)       wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down)     wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute)     wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    mic-mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
esac

RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 0.50")
MUTED=0
if [[ "$RAW" == *"[MUTED]"* ]]; then
    MUTED=1
fi
VOL=$(echo "$RAW" | awk '{print int($2 * 100)}')

if command -v minosd >/dev/null 2>&1 && minosd V "$VOL" "$MUTED" 2>/dev/null; then
    exit 0
fi

# Fallback volume notification
notify-send -r 91110 -h string:x-canonical-private-synchronous:volume -t 1500 -a "OSD" "Volume: ${VOL}%"
