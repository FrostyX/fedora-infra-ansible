#!/usr/bin/bash

set -x
set -e

swap_device=
if test -e /dev/xvda1 && test -e /dev/nvme0n1; then
    swap_device=/dev/nvme0n1
elif test -e /dev/nvme1n1; then
    swap_device=/dev/nvme1n1
fi

test -n "$swap_device"

systemctl unmask tmp.mount
systemctl start tmp.mount


echo "\
n
p


+16G
n
p
2


w
" | fdisk "$swap_device"

mkfs.ext4 "${swap_device}p1"

mount /dev/"$swap_device"p1 /var/lib/copr-rpmbuild
chown root:mock /var/lib/copr-rpmbuild
chmod 775 /var/lib/copr-rpmbuild

mkswap "${swap_device}p2"
swapon "${swap_device}p2"
