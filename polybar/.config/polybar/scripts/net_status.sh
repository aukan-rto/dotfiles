#!/bin/sh

COLOR="%{F#00ff00}"
WARN="%{F#ff0000}"
RESET="%{F-}"

ETH_IP=$(ip addr show enp0s25 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
WLAN_IP=$(ip addr show wlp3s0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -n "$ETH_IP" ]; then
    echo "${COLOR}󰈀 ${RESET}$ETH_IP"
elif [ -n "$WLAN_IP" ]; then
    echo "${COLOR}󰖩 ${RESET}$WLAN_IP"
else
    echo "󰖪  Offline"
fi
