#!/bin/sh

if [ $(id -u) -ne 0 ]; then
    echo "You need root privileges to run this script."
    exit 1
fi

echo "Install Xorg"
doas pkg install -y xorg
doas pw groupmod video -m zoliky

echo "Install Intel graphics"
doas pkg install -y drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

echo "Install Xfce"
doas pkg install -y xfce xfce4-goodies plank
doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF
doas sysrc dbus_enable="YES"

#echo "Install LightDM"
doas pkg install -y lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

echo "Adjustments"
doas mv /boot/loader.conf /boot/loader.conf.backup
doas mv loader.conf /boot/

echo "Install utilities"
doas pkg install -y vim neovim htop neofetch rsync kitty tmux dfc zip mpv fzf meson

echo "Install Firefox"
doas pkg install -y firefox
doas chown -R zoliky:zoliky ~/.cache

echo "Configure sound"
doas tee -a /etc/sysctl.conf <<EOF
hw.snd.default_unit=3
EOF

echo "Install fonts"
doas pkg install -y hack-font

echo "Configure webcam"
doas pkg install -y webcamd
doas sysrc webcamd_enable="YES"
doas pw groupmod webcamd -m zoliky
doas sysrc kld_list+="cuse"

echo "Configure Wacom tablet"
doas pkg install -y libwacom
doas pkg install -y xf86-input-wacom