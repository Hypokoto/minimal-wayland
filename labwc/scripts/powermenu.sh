#!/usr/bin/env bash
# ==============================================================================
# powermenu.sh — High-Aesthetic Fullscreen Power Menu via wlogout
# Displays full-screen action buttons without search bar (wlogout / fuzzel dmenu)
# ==============================================================================
set -euo pipefail

# 1. Primary: Native wlogout with Synthwave styling (zero search bar)
if command -v wlogout >/dev/null 2>&1; then
	if pgrep -x wlogout >/dev/null 2>&1; then
		pkill -x wlogout
		exit 0
	fi
	exec wlogout -b 5 -c 20 -r 20 -m 260
fi

# 2. Fallback: Fuzzel without search bar (--hide-prompt)
entries="Lock\nLogout\nSuspend\nReboot\nShutdown"
choice=$(printf '%b' "$entries" | fuzzel --dmenu --hide-prompt --lines 5 --width 20)

case "$choice" in
	Lock)
		if command -v swaylock >/dev/null 2>&1; then
			swaylock -f -C "${XDG_CONFIG_HOME:-$HOME/.config}/swaylock/config" 2>/dev/null || swaylock -f
		fi
		;;
	Logout)
		loginctl terminate-session "${XDG_SESSION_ID:-}" 2>/dev/null \
			|| labwc --exit 2>/dev/null \
			|| pkill -u "$USER" -x labwc
		;;
	Suspend)
		systemctl suspend
		;;
	Reboot)
		systemctl reboot
		;;
	Shutdown)
		systemctl poweroff
		;;
esac
