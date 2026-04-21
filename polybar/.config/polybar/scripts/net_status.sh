#!/bin/sh

# Colores (Cian para local)
COLOR="%{F#00ffff}"
RESET="%{F-}"
WARN="%{F#ff0000}"

# Intentamos obtener la IP de Ethernet primero (enp0s25)
ETH_IP=$(ip addr show enp0s25 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -n "$ETH_IP" ]; then
    echo "${COLOR}󰈀${RESET} $ETH_IP"
else
    # Si no hay Ethernet, intentamos WiFi (wlp3s0)
    WLAN_IP=$(ip addr show wlp3s0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    
    if [ -n "$WLAN_IP" ]; then
        echo "${COLOR}󰖩${RESET} $WLAN_IP"
    else
        echo "${WARN}󰖪${RESET} Offline"
    fi
fi
