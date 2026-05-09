#!/bin/sh

IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(tun|wg)[0-9]+' | head -n1)

if [ -n "$IFACE" ]; then
    IP=$(ip -4 addr show "$IFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "$IP"
else
    echo "Desconectado"
fi
