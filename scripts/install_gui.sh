#!/bin/bash

# Gui
pacman -S i3 dmenu xorg-server xorg-apps xorg-xinit --noconfirm --needed
echo "#! /bin/bash
exec i3" > ~/.xinitrc

# terminal
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