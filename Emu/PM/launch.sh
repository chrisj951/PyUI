#!/bin/sh

PORT_FILE="$1"

is_retroarch_port() {
    echo "Checking if the port is RetroArch..."
    # Check if the file contains "retroarch"
    if grep -q "retroarch" "$PORT_FILE"; then
        return 1;
    else
        return 0;
    fi
}

run_port() {
    /mnt/SDCARD/pyui/miyoo/flip/bind-new-libmali.sh

    is_retroarch_port
    mkdir -p "/mnt/SDCARD/Saves/flip/home"
    
    export PATH="/mnt/SDCARD/pyui/bin/:$PATH"
    export HOME="/mnt/SDCARD/Saves/flip/home"

    #Keep split likke this for easier debugging
    ORIG_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

    #Common libs that ports need
    export LD_LIBRARY_PATH="/mnt/SDCARD/pyui/lib"
    export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/mnt/SDCARD/pyui/mounts/libs/lib:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/mnt/SDCARD/pyui/mounts/libs/usr/lib:$LD_LIBRARY_PATH"

    #32bit support
    export LD_LIBRARY_PATH="/usr/lib32:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/mnt/SDCARD/pyui/lib32:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="/mnt/SDCARD/pyui/mounts/libs/usr/lib32:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ORIG_LD_LIBRARY_PATH"

    echo "export HOME=$HOME"
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
    echo "export PATH=$PATH"

    if [[ $? -eq 1 ]]; then
        PORTS_DIR=/mnt/SDCARD/Roms/PM
        cd /mnt/SDCARD/RetroArch/
        "$PORT_FILE" &> /mnt/SDCARD/Emu/PM/port.log
    else
        PORTS_DIR=/mnt/SDCARD/Roms/PM
        cd $PORTS_DIR
        echo "Running $PORT_FILE"
        "$PORT_FILE" &> /mnt/SDCARD/Emu/PM/port.log
    fi
        
    /mnt/SDCARD/pyui/miyoo/flip/unbind-new-libmali.sh
}


run_port