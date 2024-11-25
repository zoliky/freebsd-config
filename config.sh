#!/bin/sh

username=zoliky

echo "Ensure packages are up-to-date"
doas pkg update && doas pkg upgrade -y

echo "Install Xorg"
doas pkg install -y xorg

echo "Install Intel graphics"
doas pkg install -y drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

echo "Enable dynamic adjustment of CPU frequency"
doas sysrc powerd_enable="YES"
doas sysrc powerd_flags="-a hiadaptive -b adaptive"

echo "Adjustments"
doas cp /boot/loader.conf /boot/loader.conf.backup
doas cp loader.conf /boot/

echo "Install utilities"
doas pkg install -y vim htop fastfetch rsync kitty tmux dfc zip mpv yt-dlp fzf meson mixertui wget

echo "Install Firefox"
doas pkg install -y firefox
doas chown -R $username:$username ~/.cache

echo "Configure sound"
doas tee -a /etc/sysctl.conf <<EOF
# USB audio
hw.snd.default_unit=3
hw.snd.default_auto=0
hw.snd.vpc_autoreset=0
EOF

echo "Enhance desktop responsiveness under high CPU use"
doas tee -a /etc/sysctl.conf <<EOF
# Enhance desktop responsiveness under high CPU use
kern.sched.preempt_thresh=200
EOF

echo "Install fonts"
doas pkg install -y hack-font

echo "Install Xfce"
doas pkg install -y xfce xfce4-goodies xfce4-pulseaudio-plugin plank xarchiver networkmgr redshift galculator xdg-user-dirs
doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF
doas sysrc dbus_enable="YES"

echo "Install and enable LightDM"
doas pkg install -y lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

echo "Configure webcam"
doas pkg install -y webcamd
doas sysrc webcamd_enable="YES"
doas sysrc kld_list+="cuse"

echo "Configure Wacom tablet"
doas pkg install -y libwacom xf86-input-wacom

echo "Add user to core groups"
doas pw groupmod operator -m $username
doas pw groupmod realtime -m $username
doas pw groupmod video -m $username
doas pw groupmod webcamd -m $username
doas pw groupmod network -m $username

echo "Clear local package cache"
doas pkg clean -y