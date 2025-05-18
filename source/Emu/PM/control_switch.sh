#!/bin/sh

CONFIG="/mnt/SDCARD/Emu/PM/config.json"

if grep -q 'X360)' "$CONFIG"; then
	  NEW_DISPLAY="X360-(✓Nintendo)"
	  echo "Changing to Nintendo"
    cp "/mnt/SDCARD/Emu/PM/gamecontrollerdb_nintendo.txt" "/mnt/SDCARD/App/PortMaster/portmaster/PortMaster/gamecontrollerdb.txt"
else 
	  NEW_DISPLAY="(✓X360)-Nintendo"
	  echo "Changing to X360"
    cp "/mnt/SDCARD/Emu/PM/gamecontrollerdb_360.txt" "/mnt/SDCARD/App/PortMaster/portmaster/PortMaster/gamecontrollerdb.txt"
fi

sed -i "s|\"Controls:.*\"|\"Controls: $NEW_DISPLAY\"|g" "$CONFIG"
