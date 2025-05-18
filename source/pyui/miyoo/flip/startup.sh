#!/bin/sh

if [ ! -f /mnt/SDCARD/use-stock-ui.txt ]; then
  killall runmiyoo.sh
fi

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

/mnt/SDCARD/pyui/miyoo/flip/recombine_large_files.sh > /mnt/SDCARD/pyui/logs/recombine_large_files.log  2>&1
/mnt/SDCARD/pyui/miyoo/flip/mount_32bit_libs.sh > /mnt/SDCARD/pyui/logs/mount_32bit_libs.log  2>&1
/mnt/SDCARD/pyui/common/mount_libs.sh > /mnt/SDCARD/pyui/logs/mount_libs.log  2>&1
/mnt/SDCARD/pyui/miyoo/flip/setup_32bit_libs.sh > /mnt/SDCARD/pyui/logs/setup_32bit_libs.log  2>&1
/mnt/SDCARD/pyui/miyoo/flip/bind_glibc.sh > /mnt/SDCARD/pyui/logs/bind_glibc.log  2>&1

# PortMaster ports location
mkdir -p /mnt/SDCARD/Roms/PM/ports/ 
mount --bind /mnt/SDCARD/Roms/PM/ /mnt/SDCARD/Roms/PM/ports/
	
# PortMaster looks here for config information which is device specific
mount --bind /mnt/SDCARD/pyui/miyoo/flip/root/ /root 


if [ ! -f /mnt/SDCARD/use-stock-ui.txt ]; then
  touch /tmp/fbdisplay_exit
  cat /dev/zero > /dev/fb0
  export PYSDL2_DLL_PATH="/lib"
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/miyoo/lib"

  /usr/miyoo/bin/miyoo_inputd &
  /usr/miyoo/bin/hardwareservice &

  while true; do
    /mnt/SDCARD/pyui/bin/python3 /mnt/SDCARD/pyui/main-ui/mainui.py
  done
else
    cd /usr/miyoo/bin/
    /usr/miyoo/bin/runmiyoo-original.sh
fi
