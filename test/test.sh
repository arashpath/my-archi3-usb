#!/bin/bash
set -e
#set -x
# Download latest iso from https://www.archlinux.org/download/ ------------- #
isofolder=/data/iso/arch
ArchMirror="http://mirror.cse.iitk.ac.in/archlinux/iso/latest"
read sha1sum archiso <<<$(curl "$ArchMirror/sha1sums.txt" \
        | sed -n '/archlinux-.*-x86_64.iso/p')
echo "Downloading ISO ..."
wget -c "$ArchMirror/$archiso" -P $isofolder
echo "$sha1sum  $archiso" > $isofolder/"$archiso"_sha1sums.txt
echo $(cd $isofolder && sha1sum -c "$archiso"_sha1sums.txt) 

  admin_user=$(awk -F\" '/admin_user=/{print $2}' ../scripts/install_base.sh)
admin_passwd=$(awk -F\" '/admin_passwd=/{print $2}' ../scripts/install_base.sh)
# Creating Vatiable File for packer
cat <<EOF >test.json
{
    "iso_url": "file://$isofolder/$archiso",
    "iso_checksum_url": "$ArchMirror/sha1sums.txt",
    "iso_checksum_type": "sha1",
    "headless": "true",
    "user": "$admin_user",
    "password": "$admin_passwd"
}
EOF

# Running packer
echo "Inspecting packer file"
packer inspect packer.json
echo "Validating packer file"
packer validate -var-file='test.json' packer.json
echo "Building image"
packer build -var-file='test.json' packer.json
