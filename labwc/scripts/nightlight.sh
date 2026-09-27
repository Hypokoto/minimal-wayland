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
	if wlsunset -T 4500 >/dev/null 2>&1 & then
		notify-send -i display-brightness "Night Light" "Activated — Warm color temperature (4500K)"
	else
		notify-send -u critical -i display-brightness "Night Light" "Failed to activate wlsunset"
	fi
fi
