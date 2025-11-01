#!/bin/bash
[ "$(id -u)" -eq 0 ] && exit 1
command -v hyprctl >/dev/null || exit 1
for config in nvim zed mako ranger kitty hypr waybar fastfetch rofi wofi fish; do
    rm -rf "${HOME}/.config/${config}"
    ln -sf "$(dirname "$(realpath "$0")")/${config}" "${HOME}/.config/"
done
if command -v hyprctl &> /dev/null; then
    hyprctl reload | grep -v "^ok$" || true
    pkill hyprpaper
    hyprpaper > /dev/null 2>&1 &
    pkill waybar
    waybar > /dev/null 2>&1 &
    echo "ваши доты готовы блять"
fi
