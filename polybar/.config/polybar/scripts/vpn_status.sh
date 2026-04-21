#!/bin/sh

IFACE=$(ip addr | grep tun0 | awk '{print $2}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
    echo "$(ip addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
else
    echo "Desconectado"
fi
