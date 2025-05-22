#!/bin/sh
./gptokeyb -k "rtc" -c "./rtc.gptk" &
sleep 1
./rtc-Flip
kill -9 $(pidof gptokeyb)
