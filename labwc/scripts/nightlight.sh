#!/usr/bin/env bash
# ==============================================================================
# nightlight.sh — Labwc Compositor Night Light Shader Toggle
# Toggles wlsunset (4500K warm color temperature) on/off
# ==============================================================================
set -euo pipefail

if pgrep -x wlsunset >/dev/null 2>&1; then
	pkill -x wlsunset >/dev/null 2>&1 || true
	notify-send -i display-brightness "Night Light" "Deactivated — Normal color temperature restored"
else
	wlsunset -T 4500 >/dev/null 2>&1 &
	notify-send -r 91114 -u low "Night Light" "Enabled (4500K)"
fi
