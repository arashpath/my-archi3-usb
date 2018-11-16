#!/bin/bash

# Gui (~12MB, ~30MB)
pacman -S i3-gaps xorg-server xorg-apps xorg-xinit ttf-dejavu ttf-inconsolata --noconfirm --needed
mkdir -p ~/.config/i3/
cp /etc/i3/config ~/.config/i3


echo "
xsetroot -solid "#333333"
feh --bg-fill ~/.config/wall.jpg
exec i3" > ~/.xinitrc


# Wallpaper (~4MB, ~13MB)
pacman -S feh wget --noconfirm --needed
wget -c "https://tweakers.net/ext/f/ph5BxUGTgCHBPHXMJ2bn4h5C/full.jpg" -P ~/.config/
echo "exec --no-startup-id feh --bg-fill ~/.config/wall.jpg" >> ~/.config/i3/config

##
# Use a compositor manager such as `compton` to enable effects like window fading and transparency.
# Use `dmenu` or `rofi` to enable customizable menus that can be launched from a keyboard shortcut.
# Use `dunst` for desktop notifications.
##


# terminal echo -e "\033(0"
pacman -S rxvt-unicode rxvt-unicode-terminfo

# Intalling Aura
pacman -S base-devel wget git # ~50 MB

# Python
pacman -S python

pacman -S htop iotop

pacman -S elinks ranger

pacman -S ttf-dejavu ttf-inconsolata

# Gui tools 
pacman -S firefox gimp vlc code
