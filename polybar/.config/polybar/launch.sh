#!/usr/bin/env bash

# 1. Limpieza radical: Matamos cualquier instancia previa
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 2. Lanzamiento inteligente
if type "xrandr" > /dev/null; then
  # Este bucle busca CADA monitor conectado y lanza una Polybar en cada uno
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main -c ~/.config/polybar/config.ini &
  done
else
  # Si xrandr falla, lanza la barra por defecto
  polybar --reload main -c ~/.config/polybar/config.ini &
fi
