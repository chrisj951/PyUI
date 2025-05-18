#!/bin/sh

if [ -f "/mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img_partaa" ]; then
    rm -f /mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img
    cat /mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img_part* > /mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img
    rm /mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img_part*
fi

if [ -f "/mnt/SDCARD/pyui/_large_files/common/libs.sqshfs_part_aa" ]; then
    rm -f /mnt/SDCARD/pyui/_large_files/common/libs.squashfs
    cat /mnt/SDCARD/pyui/_large_files/common/libs.squashfs_part_* > /mnt/SDCARD/pyui/_large_files/common/libs.squashfs
    rm /mnt/SDCARD/pyui/_large_files/common/libs.squashfs_part_aa*
fi

