#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
  echo "This script must not be run as root." >&2
  echo "Exiting."
  exit 1
fi

# Function to install packages
install_packages() {
  for package in "$@"; do
    if ! pkg info -e "$package"; then
      echo "Installing $package"
      doas pkg install -y "$package"
    fi
  done
}

copy_config() {
  source_file=$1
  target_file=$2
  backup_file="${target_file}.backup"

  # Compare files and update if they differ
  if ! cmp -s "$source_file" "$target_file"; then
    doas cp "$target_file" "$backup_file"
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

# Install Intel graphics and enable i915kms at boot
# See https://docs.freebsd.org/en/books/handbook/x11/#x-configuration-intel
install_packages drm-kmod libva-intel-driver mesa-libs mesa-dri
doas sysrc kld_list+=i915kms

# Enable powerd for dynamic CPU frequency scaling
doas sysrc powerd_enable="YES"
doas sysrc powerd_flags="-a hiadaptive -b adaptive"

# Copy custom configuration files
copy_config "loader.conf" "/boot/loader.conf"
copy_config "sysctl.conf" "/etc/sysctl.conf"

if ! cmp -s "devfs.rules" "/etc/devfs.rules"; then
  doas cp devfs.rules /etc/
  doas sysrc devfs_system_ruleset="system"
fi

# Install utilities
install_packages \
  mpv \
  vim \
  fzf \
  dfc \
  zip \
  htop \
  wget \
  kitty \
  rsync \
  meson \
  yt-dlp \
  mixertui \
  fastfetch \
  portmaster

# Install Firefox
install_packages firefox

# Fix permissions for Firefox's cache directory
if [ -d "$HOME/.cache" ]; then
  doas chown -R $USER:$USER "$HOME/.cache"
fi

# Install fonts
install_packages hack-font

# Install Xfce and other useful packages
install_packages \
  xfce \
  xfce4-goodies \
  xfce4-pulseaudio-plugin \
  gnome-keyring \
  plank \
  xarchiver \
  networkmgr \
  redshift \
  galculator \
  xdg-user-dirs

# Add proc filesystem entry to /etc/fstab
if ! grep -q '^proc' /etc/fstab; then
  doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF
fi

# Enable D-BUS
doas sysrc dbus_enable="YES"

# Install and enable LightDM display manager
install_packages lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

# Enable webcamd for USB webcam, Wacom tablet, and other devices
install_packages webcamd
doas sysrc webcamd_enable="YES"
doas sysrc kld_list+="cuse"

# Install packages for Wacom tablet support
install_packages libwacom xf86-input-wacom

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