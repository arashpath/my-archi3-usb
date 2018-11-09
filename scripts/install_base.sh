#!/bin/bash
set -e
set -x
# Installation --------------------------------------------------------------- #
disk="/dev/sda"   # specify the usb drive using
mnt="/mnt/drive"  # temporary mount point
adminUser="admin"
adminPassword="admin@123"

# Preparing the USB Drive ---------------------------------------------------- #
# Zero Fill Boot sector and create partition tables
dd if=/dev/zero of="$disk" bs=512 seek=0 count=20480 status=progress # zero fill
sgdisk -z                "$disk"  # zap anything existing 
sgdisk -o                "$disk"  # new GPT partition with protective MBR
# BIOS Boot Drive for old PC
sgdisk -n 1:0:+10M       "$disk"  # Partition 1 - everything but the last 200MB
sgdisk -t 1:ef02         "$disk"  # Set partition type to Linux
sgdisk -c 1:"BIOS"       "$disk"  # Set Part name BIOS
# EFI Boot Drive for New PC
sgdisk -n 2:0:+500M      "$disk"  # create partition 2 - last 200MB
sgdisk -t 2:ef00         "$disk"  # Set partition type to ESP
sgdisk -c 2:"UEFI"       "$disk"  # Set Part name UEFI
# ROOT and installation partition
sgdisk -n 3:0:0          "$disk"  # Root partition
sgdisk -t 3:8304         "$disk"  # Set partition type to linux x86_x64
sgdisk -c 3:"ArchLinux"  "$disk"  # Set Part name ArchLinux

# File Systems 
mkfs.fat -F32 "$disk"2 # ESP
mkfs.ext4 -O "^has_journal" "$disk"3 # Primary Linux partition
mkdir -p $mnt
mount "$disk"3 $mnt
mkdir -p $mnt/boot
mount "$disk"2 $mnt/boot

# Installing arch base (~250MB, ~1GB) ---------------------------------------- # 
pacstrap $mnt base 
# Generate fstab Entries
genfstab -U -p $mnt > $mnt/etc/fstab
arch-chroot $mnt /bin/bash <<EOF

echo "archusb" >> /etc/hostname
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Host Name Entries
echo "# Host Entries
127.0.0.1    localhost
::1          localhost
127.0.1.1    archusb.localdomain    archusb" >> /etc/hosts 

# Generating Instial RAM Disk
sed -i '/^HOOKS=/ {
    s/block //
    s/autodetect/block autodetect/p
}' /etc/mkinitcpio.conf
mkinitcpio -p linux

# Installing Grub boot loader (~6MB, ~30MB) 
pacman -S --noconfirm --needed grub efibootmgr #os-prober
grub-install --target=i386-pc --boot-directory /boot "$disk"
grub-install --target=x86_64-efi --efi-directory /boot \
--boot-directory /boot --removable
sed -i -e 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=1/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Save disk wites
sed -i '/Storage=/s/^.*$/Storage=volatile/
/SystemMaxUse=/s/^.*$/SystemMaxUse=16M/' /etc/systemd/journald.conf 

# Network Configuration (~3MB, ~10MB)
pacman -S --noconfirm --needed wpa_supplicant dialog ifplugd wpa_actiond 
# Using Old dev names i.e. eth & wlan
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
# enable network services
#systemctl enable netctl-auto@wlan0
cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/eth0-dhcp
systemctl enable netctl-ifplugd@eth0

# Required (~15MB, ~80MB)
pacman -S --noconfirm --needed sudo openssh vim tmux git
systemctl enable sshd

# grml-zsh-config zsh-completions

# All Genric Video Drivers (~43MB, ~183MB)
pacman -S --noconfirm --needed xf86-video-ati xf86-video-intel \
xf86-video-nouveau xf86-video-vesa

# Laptop Touch Pad & Battery (~0MB, ~1MB)
pacman -S --noconfirm --needed xf86-input-synaptics acpi

#USER Configuration
# Zsh as in Arch installation iso (~2MB, ~7MB)
pacman -S --noconfirm --needed grml-zsh-config zsh-completions
#Change Root shell
#chsh -s /usr/bin/zsh
# Admin User with password less sudo and zsh
useradd -m $adminUser -s /usr/bin/zsh
echo "$adminUser":"$adminPassword" | chpasswd
echo "$adminUser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$adminUser
chmod 0440 /etc/sudoers.d/$adminUser

# Exit
exit
EOF
 
umount $mnt/boot $mnt
echo "Remove CD and Reboot"

#base-devel vim \
#	wpa_supplicant dialog \
#	grml-zsh-config zsh-completions \
#	openssh sudo
#hwclock --systohc

# Default rule copied from ArchISO 
# cat <<EOF > /etc/udev/rules.d/81-dhcpcd.rules
# ACTION=="add", SUBSYSTEM=="net", ENV{INTERFACE}=="en*|eth*", ENV{SYSTEMD_WANTS}="dhcpcd@$name.service"
# EOF

#pacman -S ansible vagrant virtualbox packer

# Network Driver
#pacman -S iw

# My Admin Tools
#pacman -S packer aws-cli ansible 
# My Lab tools
#pacman -S vagrant virtualbox

# Permissions ~11MB
#pacman -S polkit

## All packages from ISO
#pacman -S $( curl https://git.archlinux.org/archiso.git/plain/configs/releng/packages.x86_64)

## recommended
#git clone https://github.com/arcmags/archlinux-usb
