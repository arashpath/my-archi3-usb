# Installing Arch on USB
Installing arch on a USB Drive, Simple Scriptable installation procedure.

## Prerequisites
  - USB pen driver at lease 8GB
  - [Installation media](#installation-media)
  - [VM / PC for Installation](#installation)
  - [Internet Connection](#)

- References
    - [ValleyCat](http://valleycat.org/linux/arch-usb.html)
    - [ArchWiki](https://wiki.archlinux.org/index.php/Installation_guide)
    - [GUI n Stuff](https://tutos.readthedocs.io/en/latest/source/Arch.html)

## Steps
- [ ] Create VM without hdd and boot from latest Arch ISO
- [ ] Attache USB Drive check drive name using `lsblk`, usually `/dev/sda`
- [ ] Preparing for Installation
  - [ ] Check Internet Connection `ping archlinux.org`
  - [ ] Set root passwd `passwd` and enable ssh `systemctl start sshd`
  - [ ] Enable fastest Mirror
    ```
    sudo pacman -Sy --noconfirm --needed reflector pacman-contrib
    
    sudo reflector -l 100 -f 50 --sort rate --threads 5 --verbose \
    --save /tmp/mirrorlist.new && \
    rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist && \
    sudo cp /tmp/mirrorlist /etc/pacman.d
    
    cat /etc/pacman.d/mirrorlist
    sudo pacman -Syy
    ```
### Installation Media
- Downloading the latest ISO.
  ```
  # Download latest iso from https://www.archlinux.org/download/ ------------- #
  ArchMirror="http://mirror.cse.iitk.ac.in/archlinux/iso/latest"
  wget -c "$ArchMirror/md5sums.txt"
  sed -i '/archlinux-bootstrap/d' md5sums.txt
  read md5sum archiso <<<$(cat md5sums.txt)
  wget -c "$ArchMirror/$archiso"
  md5sum -c md5sums.txt
  # -------------------------------------------------------------------------- #
  ```
- Making USB Installation media (not req. if using iso in VM)
  - `dd bs=4M if=/path/archlinux.iso of=/dev/sdX status=progress && sync`

### Installation
 - Create a Virtual Box with out hard disk and attache USB and ISO.
 - Boot from Arch installation media.

###



```
# check avilable disks and enable networking
#lsblk
#ip link
#ip link set <name> up
# set root passwd and enable ssh
#passwd
#systemctl start sshd

# Mounting USB
```
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" internalcommands createrawvmdk -filename "D:\VMs\Vbox\ArchUSB\archUSB.vmdk"
```
```