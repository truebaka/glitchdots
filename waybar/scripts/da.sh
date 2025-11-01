#!/bin/bash

if pgrep rofi > /dev/null; then
pkill rofi

else
hyprctl dispatch exec "rofi -show drun"
fi
