#!/bin/sh
/usr/bin/ffmpeg -ss 00:00:03.333 -i "$1" -vf "select=eq(n\,99)" -vframes 1 "$2".png
#/usr/bin/ffmpeg -ss 00:00:03.333  -vf "select=eq(n\,99)" $1 $2

