#!/bin/sh
amixer -c 0 cset name='Capture MIC Path' 'Main Mic'	> /dev/null
amixer sset Master 65536,65536 > /dev/null
for i in {1..1000}; do
	echo "当前状态正在录音，请讲话..."
	arecord -r 44100 -f S16_LE -d 5 .record.wav
	echo "当前状态正在播放，请听..."
	aplay .record.wav
done

