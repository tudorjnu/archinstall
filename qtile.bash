#!/bin/bash

# VARIABLES
COUNTRY="United Kingdom"

sudo timedatectl set-ntp true
sudo reflector --country "$COUNTRY" --age 12 --sort rate --save /etc/pacman.d/mirrorlist

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd
rm -rf paru

echo "Installing packages"
sudo pacman -S \
  firefox \
  picom \
  ly \
  qtile python-psutil python-pywlroots \
  ttf-ubuntu-nerd ttf-ubuntu-mono-nerd ttf-jetbrains-mono-nerd \
  fzf github-cli bat diff-so-fancy starship pass rofi xdg-user-dirs xclip keychain flameshot \
  snap-pac udiskie imagemagick inkscape mpd \
  polkit-gnome polkit

echo "Theeming"
sudo pacman -S \
  pop-gtk-theme papirus-icon-theme

paru -S hardcode-tray papirus-folders
# set up hardcode-tray
sudo -E hardcode-tray --size 22 --theme Papirus

# set up papirus-folders
sudo papirus-folders -C black --theme Papirus-Dark

# brightness control
paru -S brillo
# set permissions for brightness control

# set flatpak repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# set up tmux session
echo "Setting up tmux session"
sudo cp ./tmux@.service /etc/systemd/system/
