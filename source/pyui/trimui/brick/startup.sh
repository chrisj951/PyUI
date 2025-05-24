#!/bin/sh

killall runmiyoo.sh
killall hardwareservice
killall keymon

# So they can coexist on the same sd card currently
mount --bind /mnt/SDCARD/RetroArch/ra64.trimui_Brick /mnt/SDCARD/RetroArch/ra64.miyoo
[ -f "/mnt/SDCARD/spruce/settings/platform/retroarch-Brick.cfg" ] && mount --bind "/mnt/SDCARD/spruce/settings/platform/retroarch-Brick.cfg" "/mnt/SDCARD/RetroArch/retroarch.cfg" &

# /mnt/SDCARD/pyui/miyoo/flip/setup_mounts.sh

export PYSDL2_DLL_PATH="/usr/trimui/lib"
export LD_LIBRARY_PATH="/usr/trimui/lib"

/usr/trimui/bin/trimui_inputd &
/usr/trimui/bin/hardwareservice &

while true; do
  touch /tmp/fbdisplay_exit
  cat /dev/zero > /dev/fb0
  /mnt/SDCARD/pyui/bin/python3 /mnt/SDCARD/pyui/main-ui/mainui.py  -device TRIMUI_BRICK
done
