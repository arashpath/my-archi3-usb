#!/bin/bash
set -e
#set -x
# Download latest iso from https://www.archlinux.org/download/ ------------- #
ArchMirror="http://mirror.cse.iitk.ac.in/archlinux/iso/latest"
read sha1sum archiso <<<$(curl "$ArchMirror/sha1sums.txt" \
        | sed -n '/archlinux-.*-x86_64.iso/p')
wget -c "$ArchMirror/$archiso" -P iso
echo "$sha1sum  $archiso" > iso/"$archiso"_sha1sums.txt

cd iso; sha1sum -c "$archiso"_sha1sums.txt ; cd ..

# Creating Vatiable File for packer
cat <<EOF >iso.json
{
    "iso_url": "file://iso/$archiso",
    "iso_checksum_url": "$ArchMirror/sha1sums.txt",
    "iso_checksum_type": "sha1",
    "headless": "true"
}
EOF

# Running packer
packer build -var-file=iso.json archi3usb.json