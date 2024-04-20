#!/bin/sh

#if [ $(id -u) -ne 0 ]; then
#    echo "You need root privileges to run this script."
#    exit 1
#fi

username=zoliky

echo "---------- Install Xorg"
doas pkg install -y xorg
doas pw groupmod video -m $username

echo "---------- Install Intel graphics"
doas pkg install -y drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

echo "---------- Enable dynamic adjustment of CPU frequency"
doas sysrc powerd_enable="YES"
doas sysrc powerd_flags="-a hiadaptive -b adaptive"

echo "Adjustments"
doas mv /boot/loader.conf /boot/loader.conf.backup
doas mv loader.conf /boot/

echo "Install utilities"
doas pkg install -y vim neovim htop neofetch rsync kitty tmux dfc zip mpv fzf meson

echo "Install Firefox"
doas pkg install -y firefox
doas chown -R $username:$username ~/.cache

echo "Configure sound"
doas tee -a /etc/sysctl.conf <<EOF
hw.snd.default_unit=3
EOF

echo "Enhance desktop responsiveness under high CPU use"
doas tee -a /etc/sysctl.conf <<EOF
# Enhance desktop responsiveness under high CPU use
kern.sched.preempt_thresh=224
EOF

echo "Enhance shared memory"
doas tee -a /etc/sysctl.conf <<EOF
# Enhance shared memory
kern.ipc.shmmax=1000000000
kern.ipc.shm_use_phys=1
kern.ipc.shmall=256000
EOF

echo "Install fonts"
doas pkg install -y hack-font

echo "Configure webcam"
doas pkg install -y webcamd
doas pw groupmod webcamd -m $username
doas sysrc webcamd_enable="YES"
doas sysrc kld_list+="cuse"

echo "Configure Wacom tablet"
doas pkg install -y libwacom xf86-input-wacom