#!/bin/sh

if [ -f /mnt/SDCARD/use-stock-ui.txt ]; then
    rm /mnt/SDCARD/use-stock-ui.txt
else
    touch /mnt/SDCARD/use-stock-ui.txt
fi

reboot