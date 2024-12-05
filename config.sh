#!/bin/sh

# FILE:        config.sh
# DESCRIPTION: Script for setting up a FreeBSD system
# AUTHOR:      Zoltan Kiraly

# Abort execution if the script is run as root
if [ "$(id -u)" -eq 0 ]; then
  echo "This script must not be run as root." >&2
  echo "Exiting."
  exit 1
fi

# Abort execution if the 'doas' utility is not found
if ! which doas > /dev/null 2>&1; then
  echo "This script requires the 'doas' utility."
  echo "Exiting."
  exit 1
fi

# Function to install packages
install_packages() {
  for package in "$@"; do
    if ! pkg info -e "$package"; then
      echo "Installing $package."
      doas pkg install -y "$package"
    fi
  done
}

# Function to update target file with source if they differ
update_file() {
  source_file=$1
  target_file=$2
  backup_file="${target_file}.backup"

  # Check if the target file differs from the source file
  if ! cmp -s "$source_file" "$target_file"; then
    # Create a backup of the target file if it doesn't exist
    if [ ! -f "$backup_file" ]; then
      doas cp "$target_file" "$backup_file"
    fi

    # Replace the target file with the source file
    doas cp "$source_file" "$target_file"
  fi
}

# Update FreeBSD repository catalog and upgrade packages
doas pkg update && doas pkg upgrade -y

# Install git
install_packages git

# Install the Ports Collection if not present
if [ ! -d "/usr/ports" ] || [ -z "$(ls -A /usr/ports)" ]; then
  doas git clone --depth 1 https://git.FreeBSD.org/ports.git -b 2024Q4 /usr/ports
fi

# Install X.Org
install_packages xorg

# Install Intel Graphics and enable i915kms at boot
install_packages drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

# Enable powerd for dynamic CPU frequency scaling
doas sysrc powerd_enable="YES"
doas sysrc powerd_flags="-a hiadaptive -b adaptive"

# Update target files with custom configurations (source -> target)
update_file "loader.conf" "/boot/loader.conf"
update_file "sysctl.conf" "/etc/sysctl.conf"

if ! cmp -s "devfs.rules" "/etc/devfs.rules"; then
  doas cp devfs.rules /etc/devfs.rules
  doas sysrc devfs_system_ruleset="system"
fi

# Install utilities and fonts
install_packages \
  mpv vim fzf dfc zip htop wget kitty rsync meson lsblk yt-dlp \
  mixertui hack-font fastfetch portmaster

# Install Firefox
install_packages firefox

# Fix permissions for Firefox's cache directory
if [ -d "$HOME/.cache" ]; then
  doas chown -R $USER:$USER "$HOME/.cache"
fi

# Install Xfce and other useful packages
install_packages \
  xfce xfce4-goodies xfce4-pulseaudio-plugin gnome-keyring \
  plank xarchiver networkmgr redshift galculator xdg-user-dirs

# Add proc filesystem entry to /etc/fstab
grep -q '^proc' /etc/fstab || doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF

# Enable D-BUS
doas sysrc dbus_enable="YES"

# Install and enable LightDM display manager
install_packages lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

# Install Zsh and Oh My Zsh
install_packages zsh ohmyzsh

# Change the default shell to Zsh
if which zsh > /dev/null 2>&1; then
  doas chsh -s $(which zsh) $USER
fi

# Install and enable support for webcam and Wacom tablet
install_packages webcamd libwacom xf86-input-wacom
doas sysrc webcamd_enable="YES"
doas sysrc kld_list+="cuse"

# Enable FuseFS to access cloud storage services with rclone
doas sysrc kld_list+="fusefs"

# Add user to necessary groups
groups="operator realtime video webcamd network"

for group in $groups; do
  if ! id -nG "$USER" | grep -qw "$group"; then
    echo "Adding $USER to $group group"
    doas pw groupmod "$group" -m "$USER"
  fi
done

# Clear local package cache
doas pkg clean -y