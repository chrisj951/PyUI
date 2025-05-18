#!/bin/sh

if [ -f /mnt/SDCARD/miyoo355/app/MainUI.bak ]; then
    rm /mnt/SDCARD/miyoo355/app/MainUI
    mv /mnt/SDCARD/miyoo355/app/MainUI.bak /mnt/SDCARD/miyoo355/app/MainUI
else
    mv /mnt/SDCARD/miyoo355/app/MainUI /mnt/SDCARD/miyoo355/app/MainUI.bak
    rm /mnt/SDCARD/miyoo355/app/MainUI
    cp /mnt/SDCARD/pyui/miyoo/flip/startup.sh /mnt/SDCARD/miyoo355/app/MainUI
fi

reboot