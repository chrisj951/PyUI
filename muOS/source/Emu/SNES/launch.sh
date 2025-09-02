#!/bin/sh




#echo 'performance' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

#exec /usr/bin/retroarch -v -f \
#  -c /run/muos/storage/info/config/retroarch.cfg \
#  --appendconfig /tmp/ra_autoload_once.cfg \
#  -L /mnt/mmc/MUOS/core/km_ludicrousn64_2k22_xtreme_amped_libretro.so "$1"

# First argument is the full path to the ROM
rompath="$1"

# Extract just the filename
romfile="$(basename "$rompath")"

# Strip extension for the first line
title="${romfile%.*}"

# Run the launch script
/opt/muos/script/launch/lr-general.sh "$title" "snes9x_libretro.so" "$rompath"