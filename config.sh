#!/bin/sh

username=zoliky

# Update repository catalog and upgrade packages
doas pkg update && doas pkg upgrade -y

# Install X.Org
doas pkg install -y xorg

# Install Intel graphics and enable i915kms at boot
doas pkg install -y drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

# Enable powerd and set flags: hiadaptive on AC, adaptive on battery
doas sysrc powerd_enable="YES"
doas sysrc powerd_flags="-a hiadaptive -b adaptive"

# Copy custom configuration files
doas cp /boot/loader.conf /boot/loader.conf.backup
doas cp loader.conf /boot/

doas cp devfs.rules /etc/
doas sysrc devfs_system_ruleset="system"

# Install utilities
doas pkg install -y vim htop fastfetch rsync kitty tmux dfc zip mpv yt-dlp fzf meson mixertui wget

# Install Firefox
doas pkg install -y firefox
doas chown -R $username:$username ~/.cache

# Configure USB audio (Behringer UCA202)
doas tee -a /etc/sysctl.conf <<EOF
# USB audio
hw.snd.default_unit=3
hw.snd.default_auto=0
hw.snd.vpc_autoreset=0
EOF

# Set a threshold value more suitable for desktop use
doas tee -a /etc/sysctl.conf <<EOF
# Set a threshold value more suitable for desktop use
kern.sched.preempt_thresh=200
EOF

# Install fonts
doas pkg install -y hack-font

# Install Xfce with additional packages and enable D-BUS
doas pkg install -y xfce xfce4-goodies xfce4-pulseaudio-plugin plank xarchiver networkmgr redshift galculator xdg-user-dirs
doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF
doas sysrc dbus_enable="YES"

# Install and enable LightDM display manager
doas pkg install -y lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

# Enable webcamd for USB webcam, Wacom tablet, and other devices
doas pkg install -y webcamd
doas sysrc webcamd_enable="YES"
doas sysrc kld_list+="cuse"

# Install packages for Wacom tablet support
doas pkg install -y libwacom xf86-input-wacom

# Add user to core groups
doas pw groupmod operator -m $username
doas pw groupmod realtime -m $username
doas pw groupmod video -m $username
doas pw groupmod webcamd -m $username
doas pw groupmod network -m $username

# Clear local package cache
doas pkg clean -y