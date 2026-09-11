#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Set Weather Location
# @vicinae.description "Sets NEUX's location to get for weather. Set to 'delete' to remove"
# @vicinae.icon $HOME/.local/share/vicinae/scripts/NEUX/setweather.png
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/bash"]
# @vicinae.argument1 { "type": "text", "placeholder": "Town, Co-ordinates, IATA code or 'delete'" }
cd "$HOME/.config/NEUX/"

./weather.sh set-location $1
