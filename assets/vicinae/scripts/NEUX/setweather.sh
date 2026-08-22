#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Set Weather Location
# @vicinae.description "Sets NEUX's location to get for weather. Set to 'delete' to remove"
# @vicinae.icon /home/blade0/.local/share/vicinae/scripts/NEUX/setweather.png
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/bash"]
# @vicinae.argument1 { "type": "text", "placeholder": "Town, Co-ordinates, IATA code or 'delete'" }
cd /home/blade0/.config/NEUX/

./weather.sh set-location $1
