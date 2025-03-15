#!/bin/sh
if [ ! -e /sys/module/hci_uart ]
then
	echo 0 > /sys/class/rfkill/rfkill0/state
	sleep 2
	echo 1 > /sys/class/rfkill/rfkill0/state
	sleep 2

	insmod /usr/lib/modules/hci_uart.ko
	rtk_hciattach -n -s 115200 /dev/ttyS8 rtk_h5 &
	sleep 5
	hciconfig hci0 up
	#/usr/libexec/bluetooth/bluetoothd -C &
else
	hciconfig hci0 up
fi
