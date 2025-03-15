#!/bin/sh
sleep 1
if [ ! -f /sys/class/rtc/rtc0/name ]; then
  exit 1
fi
exit 0
