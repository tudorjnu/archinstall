#!/bin/bash

# System Base
sudo pacman -S base base-devel linux linux-firmware linux-headers linux-lts linux-lts-headers intel-ucode efibootmgr grub os-prober lvm2 btrfs-progs

# Development Tools
paru -S neovim git github-cli fzf rust paru paru-debug forgit tmux tree-sitter-cli python-dateutil python-psutil sassc

# Networking
sudo pacman -S networkmanager network-manager-applet openssh iwd cronie reflector fail2ban cockpit cockpit-packagekit cockpit-storaged

# File Systems & Disk Tools
sudo pacman -S dosfstools mtools ntfs-3g smartmontools snapper snap-pac udiskie

# Audio
sudo pacman -S alsa-firmware alsa-utils pipewire-alsa pipewire-docs pipewire-pulse pipewire-v4l2 pipewire-zeroconf sof-firmware noise-suppression-for-voice

# Display & Input
sudo pacman -S xorg-server xorg-server-common xorg-server-devel xorg-server-xephyr xorg-server-xnest xorg-server-xvfb \
  xorg-xwayland xorg-xrandr xorg-xinput xorg-xsetroot xorg-xkill xorg-xbacklight xorg-xgamma xorg-xdpyinfo \
  xorg-xev xorg-xauth xorg-xhost xorg-setxkbmap libinput-gestures

# Fonts
paru -S ttf-jetbrains-mono-nerd ttf-noto-nerd ttf-ubuntu-nerd ttf-ubuntu-mono-nerd terminus-font

# Xfce Thunar File Manager & Plugins
sudo pacman -S thunar thunar-archive-plugin thunar-media-tags-plugin thunar-nextcloud-plugin thunar-shares-plugin thunar-vcs-plugin thunar-volman

# GNOME Tools
sudo pacman -S nautilus nemo eog eog-docs eog-plugins gnome-themes-extra gnome-shell

# Appearance
paru -S lxappearance materia-gtk-theme papirus-icon-theme papirus-folders zafiro-icon-theme pop-gtk-theme

# System Utilities
sudo pacman -S acpid man-db man-pages bash-completion hwinfo keychain bluez bluez-utils blueman bluetuith tlp tlp-rdw tlpui cups brillo
sudo systemctl enable --now acpid.service

# Bluetooth
sudo pacman -S blueman bluetuith bluez bluez-utils

# Shell Enhancements
paru -S starship bat ripgrep tldr alacritty lf rofi

# File Archivers
sudo pacman -S 7zip unzip

# Security
sudo pacman -S firewalld fail2ban pass

# Multimedia
sudo pacman -S mpv cheese flameshot youtube-music qmk

# Texlive (LaTeX Packages)
sudo pacman -S texlive-basic texlive-bibtexextra texlive-binextra texlive-context texlive-fontsextra \
  texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-games texlive-humanities \
  texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience \
  texlive-metapost texlive-music texlive-pictures texlive-plaingeneric texlive-pstricks texlive-publishers texlive-xetex

# Nvidia Graphics
sudo pacman -S nvidia nvidia-utils nvidia-lts nvidia-settings

# Miscellaneous Tools
sudo pacman -S ethtool redshift mons zathura zathura-pdf-poppler xclip xdotool wmctrl poweralertd tzupdate

# Applications
sudo pacman -S firefox thunderbird flatpak nextcloud-client allacrity

# Documentation
read -p "Install arch-wiki? [Y/n] " install_archwiki
if [[ -z "$install_archwiki" || "${install_archwiki,,}" == "y" ]]; then
  echo "Installing packages..."
  sudo pacman -S arch-wiki-docs arch-wiki-lite
else
  echo "Installation canceled."
fi

read -p "Install qtile? [Y/n] " install_qtile
if [[ -z "$install_qtile" || "${install_qtile,,}" == "y" ]]; then
  echo "Installing packages..."
  sudo pacman -S qtile dunst picom polkit-gnome brillo
else
  echo "Installation canceled."
fi
