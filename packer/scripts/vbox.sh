#!/bin/sh

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso
rm -f /home/vagrant/.vbox_version
if [[ $VBOX_VERSION = "4.3.10" ]]; then
    ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi
yum -y remove gcc cpp kernel-devel kernel-headers perl
