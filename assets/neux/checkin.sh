#!/usr/bin/env bash
sleep 10
programs=(ironbar vicinae swaync swayosd)

if [ -n "$SWAYSOCK" ]; then
    programs+=(swaybg)
else
    programs+=(hyprpaper)
fi
missing=()

for p in "${programs[@]}"; do
    pgrep -f "$p" >/dev/null || missing+=("$p")
done

if [ "${#missing[@]}" -gt 0 ]; then
    art='  ███            ███            ███
 ░░░███     ███ ░███  ███     ███░ 
   ░░░███  ░░░█████████░    ███░   
     ░░░███  ░░░█████░    ███░    
      ███░    █████████  ░░░███   
    ███░    ███░░███░░███  ░░░███ 
  ███░      ░░░  ░███ ░░░     ░░░███
 ░░░            ░░░            ░░░'
    kitty --hold -e bash -c "printf '\033[91m%s\033[m\n\n\033[32m\033[1m%s\n\n\033[mThis shell was created as a last-ditch attempt to help you out here, in case keybinds\nor all other programs fail. I would suggest running the programs above to see what\ngoes wrong, and either fixing the problem yourself, or reaching out for help at \n\033[36m\033[4mhttps://neux.blade0.net/discord\033[m.\n\n\033[1mGood luck.\033[m\n' '$art' '${missing[*]}'"
fi
