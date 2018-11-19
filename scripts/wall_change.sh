#!/bin/bash

bg_url="http://wallpoper.com/images/00/38/82/16/ruins-wall_00388216.jpg"
#sudo pacman -S feh wget --noconfirm --needed
wget -O ~/.config/wall.jpg $bg_url
feh --bg-fill ~/.config/wall.jpg
setsid wal -i ~/.config/wall.jpg
neofetch