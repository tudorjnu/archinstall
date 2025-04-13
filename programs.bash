#!/bin/bash
set -e

# --- Initial Setup ---
echo "🔧 Starting system setup..."
sudo pacman -Syu --noconfirm

# --- Hardware Detection ---
read -p "Is this an Intel system? [y/N] " is_intel
read -p "Is this a laptop? [y/N] " is_laptop
read -p "Install NVIDIA drivers? [y/N] " install_nvidia
read -p "Install Qtile window manager setup? [Y/n] " install_qtile
read -p "Install Arch Wiki packages? [Y/n] " install_archwiki

# --- Base System ---
echo "📦 Installing base packages..."
sudo pacman -S --noconfirm base base-devel linux linux-firmware linux-headers linux-lts linux-lts-headers efibootmgr grub os-prober lvm2 btrfs-progs cpupower
sudo systemctl enable --now cpupower.service

# Microcode
if [[ "${is_intel,,}" == "y" ]]; then
  sudo pacman -S --noconfirm intel-ucode
else
  sudo pacman -S --noconfirm amd-ucode
fi

# --- AUR Helper: Paru ---
if ! command -v paru &>/dev/null; then
  echo "📦 Installing Paru (AUR Helper)..."
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm
  cd ..
  rm -rf paru
fi

# --- Time & Man Pages ---
sudo pacman -S --noconfirm man-db man-pages bash-completion chrony
sudo systemctl enable --now chronyd cronie

# --- Networking ---
sudo pacman -S --noconfirm networkmanager network-manager-applet openssh iwd cockpit cockpit-packagekit cockpit-storaged
sudo systemctl enable --now NetworkManager iwd systemd-networkd

# --- Package Mirror Management ---
sudo pacman -S --noconfirm reflector
sudo systemctl enable --now reflector.timer

# --- File Systems & Disk Tools ---
sudo pacman -S --noconfirm dosfstools mtools ntfs-3g snapper snap-pac udiskie gvfs
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer

# --- Audio ---
sudo pacman -S --noconfirm alsa-firmware alsa-utils pipewire pipewire-alsa pipewire-docs pipewire-pulse pipewire-v4l2 pipewire-zeroconf sof-firmware noise-suppression-for-voice

# --- Display & Input ---
sudo pacman -S --noconfirm xorg xclip

# --- Security ---
sudo pacman -S --noconfirm firewalld fail2ban pass
sudo systemctl enable --now firewalld fail2ban

# --- NVIDIA (optional) ---
if [[ "${install_nvidia,,}" == "y" ]]; then
  sudo pacman -S --noconfirm nvidia-dkms nvidia-settings nvidia-utils
fi

# --- Development Tools ---
paru -S --noconfirm neovim git github-cli fzf rust paru paru-debug forgit tmux tree-sitter-cli python-dateutil python-psutil sassc go lazygit

# --- Shell Enhancements & Utilities ---
sudo pacman -S --noconfirm ethtool keychain hwinfo starship bat ripgrep tldr

# --- Fonts & Theming ---
paru -S --noconfirm ttf-jetbrains-mono-nerd ttf-noto-nerd ttf-ubuntu-nerd ttf-ubuntu-mono-nerd terminus-font
sudo pacman -S --noconfirm gtk-engine-murrine gnome-themes-extra lxappearance sassc
paru -S --noconfirm tela-icons-theme

# --- Orchis Theme ---
echo "🎨 Installing Orchis theme..."
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh -t grey -c dark -i arch -l --tweaks solid
sudo ./install.sh -t grey -c dark -i arch --tweaks solid
cd ..
rm -rf Orchis-theme

# GTK Config
sudo mkdir -p /etc/gtk-2.0 /etc/gtk-3.0
ln -sf $HOME/.gtkrc-2.0 /etc/gtk-2.0/gtkrc
ln -sf $HOME/.config/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

# --- Desktop Applications (DE-agnostic) ---
sudo pacman -S --noconfirm firefox thunderbird flatpak nextcloud-client

# Flatpak setup
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# --- Multimedia & PDFs ---
sudo pacman -S --noconfirm youtube-music zathura zathura-pdf-poppler

# --- File Management & Archivers ---
sudo pacman -S --noconfirm 7zip unzip thunar thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin thunar-vcs-plugin thunar-volman tumbler ffmpegthumbnailer
paru -S --noconfirm thunar-nextcloud-plugin ffmpeg-audio-thumbnailer

# --- Printing & Bluetooth ---
sudo pacman -S --noconfirm cups blueman bluetuith bluez bluez-utils
sudo systemctl enable --now cups.service bluetooth.service blueman-mechanism.service

# --- Arch Wiki (Optional) ---
if [[ -z "$install_archwiki" || "${install_archwiki,,}" == "y" ]]; then
  sudo pacman -S --noconfirm arch-wiki-docs arch-wiki-lite
fi

# --- Qtile & WM Utilities (Optional) ---
if [[ -z "$install_qtile" || "${install_qtile,,}" == "y" ]]; then
  echo "🧩 Installing Qtile and tiling WM utilities..."

  # Core Qtile stack
  sudo pacman -S --noconfirm qtile dunst picom polkit-gnome autorandr arandr

  # WM-style tools
  sudo pacman -S --noconfirm alacritty lf rofi xss-lock i3lock redshift mons tzupdate
  paru -S --noconfirm brillo

  sudo systemctl enable --now autorandr
fi

# --- Laptop Utilities ---
if [[ "${is_laptop,,}" == "y" ]]; then
  echo "🔋 Installing laptop utilities..."
  sudo pacman -S --noconfirm powertop cbatticon batsignal
  sudo cp ./systemd/powertop.service /etc/systemd/system/
  sudo systemctl enable --now powertop.service batsignal.service
  sudo powertop --calibrate
fi

# --- Miscellaneous Tools ---
sudo pacman -S --noconfirm qmk flameshot

# --- Sleep Configuration ---
echo "💤 Installing custom sleep configuration..."
sudo mkdir -p /etc/systemd/sleep.conf.d
sudo cp systemd/sleep.conf /etc/systemd/sleep.conf.d/zzz-custom-sleep.conf

# Backup and remove main sleep.conf if exists
if [ -f /etc/systemd/sleep.conf ]; then
  echo "📁 Backing up /etc/systemd/sleep.conf..."
  sudo cp /etc/systemd/sleep.conf /etc/systemd/sleep.conf.back
  sudo rm -f /etc/systemd/sleep.conf
fi

# --- Input Configuration (Libinput) ---
echo "🖱️  Installing libinput touchpad config..."

sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp ./X11/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf

# --- Reboot Prompt ---
read -p "✅ Setup complete. Reboot now? [y/N] " reboot_now
if [[ "${reboot_now,,}" == "y" ]]; then
  sudo reboot
fi
