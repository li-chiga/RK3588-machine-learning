#!/bin/sh
amixer -c 3 cset name='PCM Volume' '192' '192' > /dev/null
for i in {1..1000}; do
	echo "当前状态正在录音，请讲话..."
	arecord -r 44100 -f S16_LE -d 5 .record.wav
	echo "当前状态正在播放，请听..."
	aplay .record.wav
done

