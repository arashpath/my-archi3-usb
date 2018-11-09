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
cat <<EOF >test.json
{
    "variables": {
        "iso_url": "file://iso/$archiso",
        "iso_checksum_url": "$ArchMirror/sha1sums.txt",
        "iso_checksum_type": "sha1",
        "disk_size": "8192",
        "memory": "512",
        "cpus": "1",
        "write_zeroes": "",
        "boot_wait": "30s",
        "headless": "false",
        "adminuser": "admin",
        "adminpassword": "admin@123"
    },
    "builders": [
        {
            "type": "virtualbox-iso",
            "boot_wait": "{{user `boot_wait`}}",
            "http_directory": "../scripts",
            "disk_size": "{{user `disk_size`}}",
            "guest_os_type": "ArchLinux_64",
            "iso_checksum_url": "{{user `iso_checksum_url`}}",
            "iso_checksum_type": "{{user `iso_checksum_type`}}",
            "iso_url": "{{user `iso_url`}}",
            "ssh_username": "{{user `adminuser`}}",
            "ssh_password": "{{user `adminpassword`}}",
            "ssh_port": 22,
            "ssh_wait_timeout": "10000s",
            "shutdown_command": "sudo systemctl poweroff",
            "guest_additions_mode": "disable",
            "headless": "{{user `headless`}}",
            "vboxmanage": [
                [
                    "modifyvm",
                    "{{.Name}}",
                    "--memory",
                    "{{user `memory`}}"
                ],
                [
                    "modifyvm",
                    "{{.Name}}",
                    "--cpus",
                    "{{user `cpus`}}"
                ]
            ],
            "boot_command": [
                "<enter><wait10><wait10><wait10><wait10><wait10><enter><enter>",
                "curl -O 'http://{{.HTTPIP}}:{{.HTTPPort}}/install_base.sh'<enter><wait>",
                "bash install_base.sh && systemctl reboot<enter>"
            ]
        }
    ]
}
EOF

# Running packer
packer build test.json