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
    kitty --hold -e bash -c "echo -e '\033[91m
 ███            ███            ███
░░░███     ███ ░███  ███     ███░ 
  ░░░███  ░░░█████████░    ███░   
    ░░░███  ░░░█████░    ███░     
     ███░    █████████  ░░░███    
   ███░    ███░░███░░███  ░░░███  
 ███░     ░░░  ░███ ░░░     ░░░███
░░░            ░░░            ░░░ 

\033[mOops, it seems like 1 or more NEUX shell components failed to start.
The components that failed are listed below:
\033[32m\033[1m
${missing[*]}

\033[mThis shell was created as a last-ditch attempt to help you out here, in case keybinds
or all other programs fail. I would suggest running the programs above to see what
goes wrong, and either fixing the problem yourself, or reaching out for help at 
\033[36m\033[4mhttps://neux.blade0.net/discord\033[m.

\033[1mGood luck.\033[m
'"
fi
