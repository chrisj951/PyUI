#!/bin/sh

#ENV Variables
export PYSDL2_DLL_PATH="/mnt/SDCARD/App/PortMaster/portmaster/site-packages/sdl2dll/dll"
export PATH="/mnt/SDCARD/spruce/flip/bin/:/mnt/SDCARD/App/PortMaster/portmaster/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/spruce/flip/lib/:$LD_LIBRARY_PATH"
export HOME="/mnt/SDCARD/Saves/flip/home"

mkdir -p /mnt/SDCARD/Persistent/
mkdir -p /mnt/SDCARD/Saves/flip/home/.local/share/PortMaster/

# PM updates itself so even though we bundle a base in our release
# We never want to overwrite it
if [ ! -d "/mnt/SDCARD/App/PortMaster/portmaster" ] ; then
  mv /mnt/SDCARD/App/PortMaster/.portmaster /mnt/SDCARD/App/PortMaster/portmaster
fi

#Fix PM files to work with stock miyoo

rm /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/miyoo/PortMaster.txt
rm /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/miyoo/control.txt
rm /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/pylibs/harbourmaster/config.py
cp /mnt/SDCARD/App/PortMaster/PortMaster.txt /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/miyoo/PortMaster.txt
cp /mnt/SDCARD/App/PortMaster/control.txt /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/miyoo/control.txt
cp /mnt/SDCARD/App/PortMaster/config.py /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/pylibs/harbourmaster/config.py

rm /mnt/SDCARD/Saves/flip/home/.local/share/PortMaster/control.txt
cp /mnt/SDCARD/App/PortMaster/control.txt /mnt/SDCARD/Saves/flip/home/.local/share/PortMaster/control.txt

#Launch port master
cd /mnt/SDCARD/App/PortMaster/portmaster/PortMaster/miyoo/

cp "/mnt/SDCARD/App/PortMaster/.portmaster/device_info_Miyoo_Miyoo Flip.txt" "/mnt/SDCARD/Saves/flip/home/device_info_Miyoo_Miyoo Flip.txt"

./PortMaster.txt &> /mnt/SDCARD/pyui/logs/portmaster.log

# Fix images to be spruce compatible
/mnt/SDCARD/App/PortMaster/update_images.sh &> /mnt/SDCARD/pyui/logs/updated_images.log


