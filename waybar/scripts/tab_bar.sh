#!/bin/bash

# Получаем список только с названиями окон
windows=$(hyprctl clients -j | jq -r '.[] | select(.mapped == true) | .title')

# Выводим список в rofi
selected_title=$(echo "$windows" | rofi -dmenu -p "Windows")

# Если ничего не выбрано — выход
[ -z "$selected_title" ] && exit 0

# Ищем адрес окна по названию (если одинаковые — выберет первое)
address=$(hyprctl clients -j | jq -r --arg title "$selected_title" '.[] | select(.title == $title) | .address' | head -n 1)

# Фокусируем окно по адресу
[ -n "$address" ] && hyprctl dispatch focuswindow address:"$address"

