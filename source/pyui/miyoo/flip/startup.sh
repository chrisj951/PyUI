#!/bin/sh

killall runmiyoo.sh
killall hardwareservice
killall keymon

if [ ! -d /mnt/SDCARD/Saves/userdata-flip ]; then
    mkdir /mnt/SDCARD/Saves/userdata-flip
    cp -R /userdata/* /mnt/SDCARD/Saves/userdata-flip
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/bin
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/bluetooth
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/cfg
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/localtime
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/timezone
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/lib
    mkdir -p /mnt/SDCARD/Saves/userdata-flip/lib/bluetooth
fi

mount --bind /mnt/SDCARD/Saves/userdata-flip/ /userdata
mkdir -p /run/bluetooth_fix
mount --bind /run/bluetooth_fix /userdata/bluetooth

/mnt/SDCARD/pyui/miyoo/flip/setup_mounts.sh

touch /tmp/fbdisplay_exit
cat /dev/zero > /dev/fb0
export PYSDL2_DLL_PATH="/lib"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/miyoo/lib"

/usr/miyoo/bin/miyoo_inputd &
/usr/miyoo/bin/hardwareservice &

while true; do
  /mnt/SDCARD/pyui/bin/python3 /mnt/SDCARD/pyui/main-ui/mainui.py
done
