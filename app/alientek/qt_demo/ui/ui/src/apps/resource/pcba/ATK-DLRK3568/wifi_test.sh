#!/bin/sh
echo 0 > /sys/class/rfkill/rfkill2/state
sleep 2
echo 1 > /sys/class/rfkill/rfkill2/state
sleep 2

ifconfig wlan0 up
connmanctl scan wifi
connmanctl services | grep managed_psk

