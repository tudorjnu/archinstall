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
  snap-pac

echo "Set ssh keys"
ssh-keygen -t ed25519 -C "tudorjnu@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Set up git"
gh auth login
