#!/bin/bash
set -euo pipefail

# Путь до hyprctl и jq (если не в PATH, поправь)
HYPRCTL="$(command -v hyprctl || true)"
JQ="$(command -v jq || true)"

if [[ -z "$HYPRCTL" || -z "$JQ" ]]; then
  echo "Ошибка: требуется hyprctl и jq в PATH." >&2
  exit 1
fi

# Получаем все workspace id из hyprctl, вытаскиваем только цифры (устойчиво к "1:foo" и т.п.),
# сортируем и делаем уникальными
raw_ids=$("$HYPRCTL" workspaces -j 2>/dev/null || echo "[]")
if [[ -z "$raw_ids" || "$raw_ids" == "[]" ]]; then
  # нет данных — по умолчанию workspace 1
  next_workspace=1
else
  ids=$("$HYPRCTL" workspaces -j | "$JQ" -r '.[].id' 2>/dev/null | sed 's/[^0-9]//g' | awk 'NF' | sort -n | uniq)
  # Если нет ни одного числового id — ставим 1
  if [[ -z "$ids" ]]; then
    next_workspace=1
  else
    # Найдём первый положительный integer >=1, которого нет в списке.
    # Пример: если есть 1 2 4 5 -> вернёт 3
    i=1
    while true; do
      if ! echo "$ids" | grep -qx "$i"; then
        next_workspace=$i
        break
      fi
      i=$((i + 1))
      # защита от бесконечного цикла (на случай странных данных)
      if [[ $i -gt 9999 ]]; then
        next_workspace=$i
        break
      fi
    done
  fi
fi

# Переключаемся на найденный рабочий стол
"$HYPRCTL" dispatch workspace "$next_workspace"

