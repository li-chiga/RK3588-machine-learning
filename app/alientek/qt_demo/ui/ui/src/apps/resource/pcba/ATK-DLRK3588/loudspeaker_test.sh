#!/bin/sh
gst-play-1.0 /usr/share/sounds/test.wav
for i in {1..1000}; do
	gst-play-1.0 /usr/share/sounds/test.wav
	sleep 1
done
