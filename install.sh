#!/bin/bash

# -------------------------
# Actualizar sistema base
# -------------------------
sudo pacman -Syu --noconfirm

# -------------------------
# Agregar repositorios externos
# -------------------------

# Chaotic-AUR
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U --noconfirm 'https://cdn.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
" | sudo tee -a /etc/pacman.conf

# BlackArch
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

# -------------------------
# Repositorios oficiales
# -------------------------
sudo pacman -S --noconfirm \
coreutils mlocate p7zip curl grep eza find jq iptables \
bspwm sxhkd polybar kitty rofi picom dunst neovim zsh git \
maim feh shred lm_sensors openvpn pipewire inetutils whois \
networkmanager pamixer playerctl alsa-card-profiles \
openssl gcc rustup go python python-pip python-pipx \
awk lua perl ruby php xclip xorg wc which openssh stow \
bat openldap less tmux libreoffice

# -------------------------
# AUR / Chaotic-AUR
# -------------------------
sudo paru -S --noconfirm \
yazi code-oss librewolf geany obsidian thunar \
jetbrains-mono-nerd-font symbols-nerd-font ttf-font-awesome-6

# -------------------------
# BlackArch
# -------------------------
sudo pacman -S --noconfirm \
impacket radare2 arp-scan ncat nmap ffuf hashcat wpscan responder \
macchanger netexec whatweb nuclei dnsx subfinder chaos-client uncover \
naabu httpx metasploit bloodhound evil-winrm caido seclists powersploit

# -------------------------
# Habilitar Servicios
# -------------------------
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
systemctl --user enable pipewire pipewire-pulse
systemctl --user start pipewire pipewire-pulse

# -------------------------
# Habilitar wireplumber
# -------------------------
systemctl --user enable wireplumber
systemctl --user start wireplumber

# -------------------------
# Cambiar Shell
# -------------------------
chsh -s /bin/zsh

# -------------------------
#
# -------------------------


# -------------------------
#
# -------------------------


# -------------------------
#
# -------------------------

