#!/bin/bash
ip_address=$(ip addr show dev eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

if [ -z "$ip_address" ]; then
    exit 1
fi

ip_prefix=$(echo "$ip_address" | cut -d. -f1)

if [ "$ip_prefix" -eq 169 ]; then
    exit 1
else
    exit 0
fi
