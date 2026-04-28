#!/bin/bash

set -euo pipefail

# --- CONFIGURACIÓN DE DOTFILES ---

REPO_URL="https://github.com/aukan-rto/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# -------------------------
# Helpers
# -------------------------
log() {
  echo -e "\n[+] $1\n"
}

run() {
  echo "[*] $1"
  eval "$1"
}

# -------------------------
# Actualizar sistema base
# -------------------------
log "Actualizando sistema"
sudo pacman -Syu --noconfirm

# -------------------------
# Chaotic-AUR
# -------------------------
log "Configurando Chaotic-AUR"

if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
  sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key FBA220DFC880C036

  sudo pacman -U --noconfirm \
    https://cdn.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst \
    https://cdn.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst

  echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
fi

# -------------------------
# BlackArch
# -------------------------
log "Instalando BlackArch"

if ! pacman -Q blackarch-keyring &>/dev/null; then
  curl -fsSL https://blackarch.org/strap.sh -o strap.sh
  chmod +x strap.sh
  sudo ./strap.sh
  rm -f strap.sh
fi

# -------------------------
# Paquetes oficiales
# -------------------------
log "Instalando paquetes base"

sudo pacman -S --needed --noconfirm \
coreutils mlocate p7zip curl grep eza find jq iptables \
bspwm sxhkd polybar kitty rofi picom dunst neovim zsh git \
maim feh shred lm_sensors openvpn pipewire inetutils whois \
networkmanager pamixer playerctl alsa-card-profiles \
openssl gcc rustup go python python-pip python-pipx \
awk lua perl ruby php xclip xorg wc which openssh stow \
bat openldap tmux libreoffice yt-dlp 

# -------------------------
# paru (AUR helper)
# -------------------------
log "Verificando paru"

if ! command -v paru &>/dev/null; then
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm
  cd ..
  rm -rf paru
fi

# -------------------------
# AUR / Chaotic packages
# -------------------------
log "Instalando paquetes AUR"

paru -S --noconfirm --needed \
yazi code-oss librewolf geany obsidian thunar ly \
jetbrains-mono-nerd-font symbols-nerd-font ttf-font-awesome-6 \
qogirr-cursor-theme tokyonight-gtk-theme tokyonight-icon-theme

# -------------------------
# BlackArch tools
# -------------------------
log "Instalando herramientas BlackArch"

sudo pacman -S --noconfirm --needed \
impacket radare2 arp-scan ncat nmap ffuf hashcat wpscan responder \
macchanger netexec whatweb nuclei dnsx subfinder chaos-client uncover \
naabu httpx metasploit bloodhound evil-winrm caido seclists powersploit

# -------------------------
# Servicios systemd
# -------------------------
log "Activando servicios"

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Activación de Ly (Display Manager)
sudo systemctl disable sddm gdm lightdm 2>/dev/null || true
sudo systemctl enable ly.service

systemctl --user enable pipewire pipewire-pulse wireplumber

# -------------------------
# Clonar y configurar Dotfiles
# -------------------------
log "Clonando Dotfiles desde GitHub"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    log "La carpeta $DOTFILES_DIR ya existe, omitiendo clonación."
fi

log "Configurando Dotfiles con Stow"

if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"

    # Borrar archivos que Arch crea por defecto y que bloquean a STOW
    rm -f "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc" "$HOME/.bash_logout"
    
    # Ejecutar stow (el flag -v da información de qué está haciendo)
    stow -v .

    # Asegurar permiso de ejecución al config de bspwm
    if [ -f "$HOME/.config/bspwm/bspwmrc" ]; then
        chmod +x "$HOME/.config/bspwm/bspwmrc"
        log "Permisos aplicados a bspwmrc"
    fi
else
    log " [!] ERROR CRÍTICO: No se pudo acceder a la carpeta de dotfiles."
fi

# -------------------------
# Shell
# -------------------------
log "Cambiando shell a zsh"

if [ "$SHELL" != "/bin/zsh" ]; then
  sudo chsh -s /bin/zsh "$USER"
fi

log "Instalación completada. Ya puedes reiniciar."
