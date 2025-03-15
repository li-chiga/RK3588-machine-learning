#!/bin/sh
echo "请查看hdmi显示是否正常"
if [[ -f "/sys/class/drm/card0-HDMI-A-1/status" ]];then
echo on > /sys/class/drm/card0-HDMI-A-1/status
fi
