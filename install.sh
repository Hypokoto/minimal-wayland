#!/usr/bin/env bash
set -euo pipefail

OFFICIAL_PKGS=("labwc" "foot" "mako" "swayidle" "swaylock" "kanshi" "cage" "ly" "awww" "brightnessctl" "cliphist" "fuzzel" "grim" "lxqt-policykit" "networkmanager" "pipewire" "pipewire-pulse" "playerctl" "power-profiles-daemon" "qt5-wayland" "qt6-wayland" "scdoc" "slurp" "wireplumber" "wl-clipboard" "wlr-randr" "xdg-desktop-portal-wlr")
AUR_PKGS=("wlogout")

if command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --needed --noconfirm "${OFFICIAL_PKGS[@]}"
    if command -v yay >/dev/null 2>&1; then
        yay -S --needed --noconfirm "${AUR_PKGS[@]}"
    fi
    
    for svc in NetworkManager.service power-profiles-daemon.service; do
        if systemctl list-unit-files "$svc" 2>/dev/null | grep -qF "$svc"; then
            sudo systemctl enable --now "$svc" || true
        fi
    done
fi

bash "$(dirname "${BASH_SOURCE[0]}")/deploy.sh"
