#!/bin/sh




#echo 'performance' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

#exec /usr/bin/retroarch -v -f \
#  -c /run/muos/storage/info/config/retroarch.cfg \
#  --appendconfig /tmp/ra_autoload_once.cfg \
#  -L /mnt/mmc/MUOS/core/km_ludicrousn64_2k22_xtreme_amped_libretro.so "$1"

echo "" > /tmp/ra_no_load

# First argument is the full path to the ROM
rompath="$1"

# Extract just the filename
romfile="$(basename "$rompath")"

# Strip extension for the first line
title="${romfile%.*}"

# Run the launch script
/opt/muos/script/launch/lr-general.sh "$title" "km_ludicrousn64_2k22_xtreme_amped_libretro.so" "$rompath"

if false; then
# First argument is the full path to the ROM
rompath="$1"

# Extract just the filename
romfile="$(basename "$rompath")"

# Strip extension for the first line
title="${romfile%.*}"


# Write configs
echo "explore" > /tmp/act_go
echo "performance" > /tmp/gov_go
echo "sytstem" > /tmp/con_go

# Write rom info to /tmp/rom_go
cat > /tmp/rom_go <<EOF
$title
km_ludicrousn64_2k22_xtreme_amped_libretro.so
Nintendo N64
Nintendo N64
0
ludicrous n64 2k22 xtreme amped
/mnt/union/ROMS/
n64
$romfile
EOF

cat > /tmp/rom_go2 <<EOF
$title
km_ludicrousn64_2k22_xtreme_amped_libretro.so
Nintendo N64
Nintendo N64
0
ludicrous n64 2k22 xtreme amped
/mnt/union/ROMS/
n64
$romfile
EOF


sync

# Run the launch script
/opt/muos/script/mux/launch.sh

fi