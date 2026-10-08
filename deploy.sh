#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.config" "$HOME/.local/state"

deploy_link() {
	local src="$1" dest="$2"
	if [[ ! -e "$src" ]]; then return; fi
	local parent_dir="$(dirname "$dest")"
	mkdir -p "$parent_dir"
	if [[ -e "$dest" || -L "$dest" ]]; then
		if [[ "$(readlink "$dest" || true)" == "$src" ]]; then return; fi
		mv "$dest" "${dest}.bak.$(date +%s%N)"
	fi
	ln -sfn "$src" "$dest"
	echo "Linked $dest -> $src"
}

if compgen -G "$DOTFILES_DIR/labwc/rc.xml.d/*.xml" >/dev/null; then
	{
		echo '<?xml version="1.0" ?>'
		echo '<labwc_config>'
		cat "$DOTFILES_DIR"/labwc/rc.xml.d/*.xml
		echo '</labwc_config>'
	} > "$DOTFILES_DIR/labwc/rc.xml"
fi

deploy_link "$DOTFILES_DIR/fuzzel" "$HOME/.config/fuzzel"
deploy_link "$DOTFILES_DIR/kanshi" "$HOME/.config/kanshi"
deploy_link "$DOTFILES_DIR/swaylock" "$HOME/.config/swaylock"
deploy_link "$DOTFILES_DIR/swayidle" "$HOME/.config/swayidle"
deploy_link "$DOTFILES_DIR/mako" "$HOME/.config/mako"
deploy_link "$DOTFILES_DIR/wlogout" "$HOME/.config/wlogout"
deploy_link "$DOTFILES_DIR/labwc" "$HOME/.config/labwc"
mkdir -p "$HOME/.local/share/themes/minimal/labwc"
deploy_link "$DOTFILES_DIR/labwc/themerc" "$HOME/.local/share/themes/minimal/labwc/themerc"
deploy_link "$DOTFILES_DIR/foot" "$HOME/.config/foot"
deploy_link "$DOTFILES_DIR/cage" "$HOME/.config/cage"

if [[ -d "/etc/ly" && -f "$DOTFILES_DIR/ly/config.ini" ]]; then
    sudo cp "$DOTFILES_DIR/ly/config.ini" /etc/ly/config.ini || true
fi
if [[ -d "/usr/share/wayland-sessions" && -f "$DOTFILES_DIR/cage/cage-kiosk.desktop" ]]; then
    sudo cp "$DOTFILES_DIR/cage/cage-kiosk.desktop" /usr/share/wayland-sessions/cage-kiosk.desktop || true
fi
