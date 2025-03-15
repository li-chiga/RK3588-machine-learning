#!/bin/sh
if [[ -f "/sys/class/drm/card0-HDMI-A-1/status" ]];then
echo off > /sys/class/drm/card0-HDMI-A-1/status
fi

if [[ -f "/sys/class/drm/card0-LVDS-1/status" ]];then
echo off > /sys/class/drm/card0-LVDS-1/status
fi
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,format=NV12,width=1920,height=1080,framerate=30/1 ! kmssink

sleep 1000
