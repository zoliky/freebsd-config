#!/bin/sh

echo "Install Xorg"
doas pkg install -y xorg
doas pw groupmod video -m zoliky

#echo "Install Intel graphics"
#doas install -y drm-kmod libva-intel-driver mesa-libs mesa-dri
#doas sysrc -f /etc/rc.conf kld_list+=i915kms

echo "Install Xfce"
doas pkg install -y xfce xfce4-goodies
doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF

echo "Adjustments"
doas mv /boot/loader.conf /boot/loader.conf.backup
doas mv loader.conf /boot/