#!/bin/bash

# Выбор плеера с помощью Rofi (rofi-wayland)
# Убедитесь, что у вас установлен rofi-wayland
choice=$(echo -e "cmus\nkew" | rofi -dmenu -i -p "Выберите плеер")

# Запуск выбранного плеера в новом окне Kitty
if [ "$choice" = "cmus" ]; then
    kitty --hold -e cmus
elif [ "$choice" = "kew" ]; then
    kitty --hold -e kew
fi
