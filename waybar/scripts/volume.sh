#!/bin/bash

if  pgrep "pavucontrol" > /dev/null; then
pkill pavucontrol

else
hyprctl dispatch exec "[float;move 1400px 69px;]" pavucontrol -q
fi
