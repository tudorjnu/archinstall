#!/bin/bash

# VARIABLES
COUNTRY="United Kingdom"
KBD_LAYOUT="us"

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# set hostname
echo "Set hostname"
echo "arch" >>/etc/hostname

# set locale
echo "Set locale"
echo "en_GB.UTF-8 UTF-8" >>/etc/locale.gen
echo "LANG=en_GB.UTF-8" >>/etc/locale.conf
locale-gen

echo "Set root password"
passwd

echo "Installing packages"
pacman -S --noconfirm \
  grub \
  efibootmgr dosfstools mtools os-prober sudo sof-firmware \
  network-manager network-manager-applet \
  bash-completion openssh reflector flatpak lxappearance \
  man-db man-pages texinfo tldr \
  bluez bluez-utils \
  cups \
  pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-docs \
  acpi acpid

# Install microcode
# amd-ucode for AMD processors
# intel-ucode for Intel processors
pacman -S --noconfirm amd-ucode

# Install nvidia drivers
# nvidia proprietary drivers: nvidia nvidia-lts nvidia-utils nvidia-settings
# nvidia open source drivers: nvidia-open nvidia-utils nvidia-settings
pacman -S --noconfirm nvidia nvidia-lts nvidia-utils nvidia-settings

# if using hybrid graphics
# amd: xf86-video-amdgpu
# intel: xf86-video-intel
# pacman -S --noconfirm xf86-video-amdgpu

mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

echo "Enabbling services"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable acpid
systemctl enable reflector.timer
systemctl enable acpid

# Create a new user
echo "Create a new user"
read -p "Enter username: " username
useradd -mG wheel "$username"
passwd "$username"
echo "$username ALL=(ALL) ALL" >>/etc/sudoers.d/$username
