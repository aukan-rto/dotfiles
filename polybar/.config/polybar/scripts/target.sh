#!/bin/bash

# Ruta absoluta al archivo de estado
TARGET_FILE="/home/$USER/.config/polybar/scripts/target.txt"

# Aseguramos que el archivo existe para evitar errores de cat
touch "$TARGET_FILE"

# Leemos el contenido
CONTENT=$(cat "$TARGET_FILE" | tr -d '\n')

# Si el contenido está vacío, mostramos "No Target" en gris
# Si tiene algo, lo mostramos en blanco/negro según tu tema
if [ -z "$CONTENT" ]; then
    echo -n "%{F#666}No Target%{F-}"
else
    echo -n "%{F#ffffff}$CONTENT%{F-}"
fi
