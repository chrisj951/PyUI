#!/bin/sh
mkdir -p /mnt/SDCARD/pyui/mounts/miyoo355_rootfs_32
mkdir -p /mnt/SDCARD/pyui/mounts/miyoo355_rootfs_32/mnt
mkdir -p /mnt/SDCARD/pyui/mounts/miyoo355_rootfs_32/mnt/sdcard

mount -t squashfs /mnt/SDCARD/pyui/_large_files/miyoo/flip/miyoo355_rootfs_32.img /mnt/SDCARD/pyui/mounts/miyoo355_rootfs_32