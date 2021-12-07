#!/usr/bin/env bash

# https://www.librebyte.net/en/systems-deployment/unattended-debian-installation/

if [ "$(dpkg -s xorriso)" -eq "1" ]; then
  sudo apt -y install xorriso
fi
if [ "$(dpkg -s genisoimage)" -eq "1" ]; then
  sudo apt -y install genisoimage
fi

DEBIAN_VERSION="11.1.0"

if [ ! -f ./debian-$DEBIAN_VERSION-amd64-netinst.iso ]; then
  curl -LO# https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-$DEBIAN_VERSION-amd64-netinst.iso
fi

xorriso -osirrox on -indev debian-$DEBIAN_VERSION-amd64-netinst.iso  -extract / isofiles/

if [ ! -f ./preseed.cfg ]; then
  curl -#L https://www.debian.org/releases/stable/example-preseed.txt -o preseed.cfg
fi

chmod +w -R isofiles/install.amd/

gunzip isofiles/install.amd/initrd.gz

echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd

gzip isofiles/install.amd/initrd

chmod -w -R isofiles/install.amd/

grep -v "default vesamenu.c32" isofiles/isolinux/isolinux.cfg > isolinux.cfg
cp -f isolinux.cfg isofiles/isolinux/isolinux.cfg
rm isolinux.cfg

chmod +w -R isofiles/boot/grub/grub.cfg
{ \
  echo "set timeout_style=hidden";\
  echo "set timeout=0"; \
  echo "set default=1"; \
} >> isofiles/boot/grub/grub.cfg
chmod -w -R isofiles/boot/grub/grub.cfg

chmod a+w isofiles/md5sum.txt
md5sum `find -follow -type f` > isofiles/md5sum.txt
chmod a-w isofiles/md5sum.txt

if [ ! -f ./example-preseed.txt ]; then
  rm debian-$DEBIAN_VERSION-amd64-netinst-unattended.iso
fi
chmod a+w isofiles/isolinux/isolinux.bin
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o debian-$DEBIAN_VERSION-amd64-netinst-unattended.iso isofiles

rm -Rf ./isofiles