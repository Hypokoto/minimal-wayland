#!/usr/bin/env bash
# ==============================================================================
# clipboard.sh — Wayland Clipboard History Manager for Labwc via Cliphist & Fuzzel
# Modes:
#   clipboard.sh           # Interactive fuzzy picker to copy item back to clipboard
#   clipboard.sh --delete  # Select an item to remove from cliphist history
#   clipboard.sh --clear   # Wipe entire clipboard history
# ==============================================================================
set -euo pipefail

MODE="${1:-}"
NOTIF_ID=91116

send_notif() {
	local urgency="$1"
	local title="$2"
	local body="$3"
	if command -v notify-send >/dev/null 2>&1; then
		notify-send -r "$NOTIF_ID" -u "$urgency" -t 1500 -a "Clipboard" -i edit-copy "$title" "$body" || true
	fi
}

if command -v minclip >/dev/null 2>&1; then
	case "$MODE" in
		--clear|--wipe)
			CONFIRM=$(printf "Cancel\nWipe Entire Clipboard History" | fuzzel --dmenu --prompt "⚠️ Clear Clipboard: " --width 35 --lines 2 || true)
			if [ "$CONFIRM" = "Wipe Entire Clipboard History" ]; then
				minclip --clear
				if command -v wl-copy >/dev/null 2>&1; then
					wl-copy -c || true
				fi
				send_notif "normal" "Clipboard Wiped" "All in-memory history cleared."
			fi
			;;
		--delete)
			send_notif "low" "Clipboard Manager" "In-memory ring shifts automatically."
			;;
		*)
			SELECTION=$(minclip --list | fuzzel --dmenu --prompt "📋 " --placeholder "Search clipboard history..." --width 50 --lines 10 || true)
			if [ -n "$SELECTION" ]; then
				ID="${SELECTION%%[[:space:]]*}"
				minclip --copy "$ID"
				send_notif "low" "Copied to Clipboard" "Item restored and ready to paste."
			fi
			;;
	esac
	exit 0
fi

if ! command -v cliphist >/dev/null 2>&1 || ! command -v fuzzel >/dev/null 2>&1; then
	send_notif "critical" "Clipboard Manager" "Required tools (cliphist / fuzzel) missing."
	exit 1
fi

case "$MODE" in
	--clear|--wipe)
		CONFIRM=$(printf "Cancel\nWipe Entire Clipboard History" | fuzzel --dmenu --prompt "⚠️ Clear Clipboard: " --width 35 --lines 2 || true)
		if [ "$CONFIRM" = "Wipe Entire Clipboard History" ]; then
			cliphist wipe
			if command -v wl-copy >/dev/null 2>&1; then
				wl-copy -c || true
			fi
			send_notif "normal" "Clipboard Wiped" "All history cleared."
		fi
		;;
	--delete)
		ITEM=$(cliphist list | fuzzel --dmenu --prompt "🗑️ Delete: " --placeholder "Select entry to remove..." --width 45 --lines 10 || true)
		if [ -n "$ITEM" ]; then
			printf '%s' "$ITEM" | cliphist delete
			send_notif "low" "Item Removed" "Selected entry deleted from history."
		fi
		;;
	*)
		SELECTION=$(cliphist list | fuzzel --dmenu --prompt "📋 " --placeholder "Search clipboard history..." --width 45 --lines 10 || true)
		if [ -n "$SELECTION" ]; then
			printf '%s' "$SELECTION" | cliphist decode | wl-copy
			send_notif "low" "Copied to Clipboard" "Item restored and ready to paste."
		fi
		;;
esac
