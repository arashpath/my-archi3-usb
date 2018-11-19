#!/bin/bash

myrepo="https://raw.githubusercontent.com/arashpath/my-archi3-usb/master"

# Gui (~15MB, ~63MB)
sudo pacman -S i3 xorg-server xorg-apps xorg-xinit compton \
    ttf-dejavu ttf-inconsolata --noconfirm --needed i3-gaps

# Setup for StartX
echo 'exec i3' > ~/.xinitrc

# Little tools (~3MB, ~10MB)
sudo pacman -S elinks neofetch wget htop --noconfirm --needed

# Terminal Emulator (~1MB, ~4MB)
sudo pacman -S rxvt-unicode --noconfirm --needed
wget "$myrepo/dotfiles/.Xdefaults" -O ~/.Xdefaults

# Wallpaper (~4MB, ~13MB)
bg_url="https://tweakers.net/ext/f/ph5BxUGTgCHBPHXMJ2bn4h5C/full.jpg"
sudo pacman -S feh wget --noconfirm --needed
wget -O ~/.config/wall.jpg -c $bg_url
echo "# Set Wallpaper
exec --no-startup-id feh --bg-fill ~/.config/wall.jpg" >> ~/.config/i3/config


# Python
sudo pacman -S python --noconfirm --needed 

# tools 
sudo pacman -S python-pywal iotop ranger --noconfirm --needed

##
# Use a compositor manager such as `compton` to enable effects like window fading and transparency.
# Use `dmenu` or `rofi` to enable customizable menus that can be launched from a keyboard shortcut.
# Use `dunst` for desktop notifications.
##


# terminal echo -e "\033(0"
#pacman -S rxvt-unicode rxvt-unicode-terminfo

# Intalling Aura
pacman -S base-devel  git # ~50 MB


# Python
sudo pacman -S python --noconfirm --needed 

# tools 
sudo pacman -S python-pywal iotop ranger --noconfirm --needed




# Gui tools 
pacman -S firefox gimp vlc code

# #-solid "#333333"