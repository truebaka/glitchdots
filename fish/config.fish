if status is-interactive
    set -g my_logo /home/aleksik/Documents/glitchcore/dlyaconfig/logos/лмаопососи.jpg
    fastfetch --logo $my_logo   
    alias hiddify="su || ./Documents/appimages/Hiddify-Linux-x64.AppImage > /dev/null 2>&1; disown"
    #    alias "sudo pacman -Sybau"="sudo pacman -Syu"
    alias autoclicker="sudo theclicker run -d "/dev/input/event2" -l276 -r275 -c25 -C0 --grab"
    alias autoclickerhold="sudo theclicker run -d "/dev/input/event2" -l276 -r275 -c25 -C0 -H --grab"
    alias fischafk="sudo theclicker run -d "/dev/input/event2" -l276 -r275 -c1500 -C1500 --grab"
    set -x EDITOR nvim
    set -x VISUAL nvim
    set -gx SUDO_EDITOR nvim
    set -gx YDOTOOL_SOCKET /run/user/1000/.ydotool_socket
    function on_window_resize --on-variable COLUMNS
        if test -z (commandline)
            clear
            fastfetch --logo $my_logo
        else
        end
    end
end

