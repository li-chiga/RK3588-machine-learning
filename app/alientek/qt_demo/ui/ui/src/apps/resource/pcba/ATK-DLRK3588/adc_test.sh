#!/bin/sh
for i in {1..1000}; do
	cat /sys/bus/iio/devices/iio\:device0/in_voltage2_raw
	sleep 1
done

