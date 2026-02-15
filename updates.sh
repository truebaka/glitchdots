#!/bin/bash

# Configuration
TARGETS=("linux" "hyprland" "waybar" "nvidia-open")
CHECK_INTERVAL=3600 # 1 hour in seconds

if pgrep -x "$(basename "$0")" | grep -v $$ > /dev/null; then
    exit 1
fi

while true; do
    repo_updates=$(checkupdates 2>/dev/null)
    aur_updates=$(yay -Qua 2>/dev/null)
    all_updates=$(echo -e "$repo_updates\n$aur_updates" | sed '/^\s*$/d') # чистим пустые строки
    
    total_count=$(echo "$all_updates" | wc -l)
    
    found_critical=()
    for pkg in "${TARGETS[@]}"; do
        if echo "$all_updates" | grep -qw "$pkg"; then
            found_critical+=("$pkg")
        fi
    done

    if [ ${#found_critical[@]} -gt 0 ]; then
        msg="CRITICAL: ${found_critical[*]} (Total: $total_count)"
        notify-send -u critical -a "System Monitor" -i "software-update-urgent" \
            "Maintenance Required" "$msg"
            
    elif [ "$total_count" -gt 0 ]; then
        msg="No critical updates, but $total_count other packages ready."
        notify-send -u low -a "System Monitor" -i "software-update-available" \
            "Updates Available" "$msg"
            
    else
        notify-send -u low "System Check" "Your system is up to date."
        echo "[$(date)] System is clean"
    fi
 
    echo "[$(date)] Checked for updates" >> /tmp/updates.log

    sleep "$CHECK_INTERVAL"
done

