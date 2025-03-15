#!/bin/bash
/usr/bin/v4l2-ctl -d $1 --get-fmt-video | grep BGR3 > /dev/null 2>&1
