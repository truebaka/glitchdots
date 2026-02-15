#!/bin/bash
if [[ $(hyprctl activewindow -j | jq -r ".floating") == "true" ]]; then
    hyprctl dispatch moveactive "$2" "$3"
else
    hyprctl dispatch movewindow "$1"
fi
