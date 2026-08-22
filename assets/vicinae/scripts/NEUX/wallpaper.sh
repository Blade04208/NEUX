#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Set Wallpaper
# @vicinae.icon /home/blade0/.local/share/vicinae/scripts/NEUX/wallpaper.png
# @vicinae.mode silent
# @vicinae.exec ["/bin/bash"]

WP_PATH=$(find ~/Pictures/Wallpapers -type f | vicinae dmenu -p "Pick a wallpaper...")
hyprctl hyprpaper wallpaper , $WP_PATH
rm $HOME/.config/hypr/hyprpaper.conf
echo -e "wallpaper {
    monitor =
    path = $WP_PATH
    fit_mode = cover
}" >> $HOME/.config/hypr/hyprpaper.conf

