#!/bin/bash

# Set up git
ssh-keygen -t ed25519 -C "tudorjnu@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

gh auth login

# Setup dotbare
git clone https://github.com/kazhala/dotbare.git ~/.config/dotbare
source ~/.config/dotbare/dotbare.plugin.bash

# AUR Helper Installation
echo "Installing Paru (AUR Helper)"
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru

# Additional Packages Installation
echo "Installing additional packages"
sudo pacman -S --noconfirm \
  firefox \
  picom \
  qtile python-psutil python-pywlroots \
  ttf-ubuntu-nerd ttf-ubuntu-mono-nerd ttf-jetbrains-mono-nerd \
  fzf bat diff-so-fancy starship pass rofi xdg-user-dirs xclip flameshot \
  snap-pac udiskie imagemagick inkscape mpd \
  polkit-gnome polkit \
  alacritty \
  wget i3lock

# display manager
sudo pacman -S --noconfirm ly
sudo systemctl enable ly.service

# Theming
echo "Installing themes"
sudo pacman -S --noconfirm \
  pop-gtk-theme papirus-icon-theme

paru -S --noconfirm hardcode-tray papirus-folders

# Set up hardcode-tray
sudo -E hardcode-tray --size 22 --theme Papirus

# Set up papirus-folders
sudo papirus-folders -C black --theme Papirus-Dark

# Brightness Control
paru -S --noconfirm brillo

# Set permissions for brightness control
# (Add specific permissions commands here if needed)

# Flatpak Setup
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Tmux Session Setup
echo "Setting up tmux session"
sudo cp ./tmux@.service /etc/systemd/system/

# BTRFS Grub Snapshots
sudo systemctl enable --now grub-btrfsd


echo "Setting up Cockpit"
sudo pacman -S --noconfirm cockpit cockpit-files cockpit-machines cockpit-packagekit cockpit-storaged cockpit-pcp
sudo systemctl enable --now cockpit.socket

# Pass and PassFF Setup
sudo pacman -S --noconfirm pass
curl -sSL https://github.com/passff/passff-host/releases/latest/download/install_host_app.sh | bash -s -- firefox

# miniconda
read -p "Do you want to install Miniconda using curl? [y/N]: " install_miniconda
if [[ $install_miniconda =~ ^[Yy] ]]; then
  echo "Installing Miniconda..."

  # installing miniconda
  mkdir -p ~/.miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
  bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
  rm -rf ~/.miniconda3/miniconda.sh
  ~/.miniconda3/bin/conda init bash
  source .bashrc
  conda config --set auto_activate_base false

  echo "Miniconda installation complete."
else
  echo "Skipping Miniconda installation."
fi

# autojump
git clone https://github.com/wting/autojump.git
cd autojump
./install.py
rm -rf autojump/

# laptop battery
# cpu frequency scalling
sudo pacman -S cpupower thermald
sudo systemctl enable --now cpupower.service
sudo systemctl enable --now thermald.service

# theming
sudo pacman -S vimix-cursors orchis-theme papirus-folders papirus-icon-theme
paru -S tela-icon-theme
