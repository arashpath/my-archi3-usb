#!/bin/bash

# Gui (~12MB, ~30MB)
sudo pacman -S i3-gaps \
    xorg-server xorg-apps xorg-xinit \
    ttf-dejavu ttf-inconsolata --noconfirm --needed
mkdir -p ~/.config/i3/
cp /etc/i3/config ~/.config/i3

# Wallpaper (~4MB, ~13MB)
bg_url="https://tweakers.net/ext/f/ph5BxUGTgCHBPHXMJ2bn4h5C/full.jpg"
pacman -S feh wget --noconfirm --needed
wget -O ~/.config/wall.jpg -c $bg_url
echo "# Set Wallpaper
exec --no-startup-id feh --bg-fill ~/.config/wall.jpg" >> ~/.config/i3/config

# Setup for StartX
echo '
xsetroot -solid "#333333"
exec i3' > ~/.xinitrc



# Terminal Emulator
pacman -S rxvt-unicode --noconfirm --needed
wget "https://raw.githubusercontent.com/arashpath/my-archi3-usb/master/dotfiles/.Xdefaults"

##
# Use a compositor manager such as `compton` to enable effects like window fading and transparency.
# Use `dmenu` or `rofi` to enable customizable menus that can be launched from a keyboard shortcut.
# Use `dunst` for desktop notifications.
##


# terminal echo -e "\033(0"
pacman -S rxvt-unicode rxvt-unicode-terminfo

# Intalling Aura
pacman -S base-devel  git # ~50 MB

# Littele tooles
sudo pacman -S elinks neofetch wget htop --noconfirm --needed

# Python
sudo pacman -S python --noconfirm --needed 

# tools 
sudo pacman -S python-pywal iotop ranger --noconfirm --needed




# Gui tools 
pacman -S firefox gimp vlc code
