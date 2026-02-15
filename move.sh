#!/bin/bash
# $1 - направление (l,r,u,d), $2 - X пиксели, $3 - Y пиксели
if [[ $(hyprctl activewindow -j | jq -r ".floating") == "true" ]]; then
    hyprctl dispatch moveactive "$2" "$3"
else
    hyprctl dispatch movewindow "$1"
fi
