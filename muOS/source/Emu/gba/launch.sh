#!/bin/sh
# First argument is the full path to the ROM
rompath="$1"

# Extract just the filename
romfile="$(basename "$rompath")"

# Strip extension for the first line
title="${romfile%.*}"

rm /tmp/ra_no_load
# Run the launch script
/opt/muos/script/launch/lr-general.sh "$title" "mgba_libretro.so" "$rompath"
