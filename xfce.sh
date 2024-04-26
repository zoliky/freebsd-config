#!/bin/sh

echo "Install Xfce"
doas pkg install -y xfce xfce4-pulseaudio-plugin xfce4-goodies plank xarchiver redshift
doas tee -a /etc/fstab <<EOF
proc $(printf '\t\t\t')/proc$(printf '\t')procfs$(printf '\t')rw$(printf '\t\t')0$(printf '\t')0
EOF
doas sysrc dbus_enable="YES"

echo "---------- Install LightDM"
doas pkg install -y lightdm lightdm-gtk-greeter
doas sysrc lightdm_enable="YES"

echo "Configure Xfce"
xfconf-query -c xfce4-power-manager \
             -p /xfce4-power-manager/blank-on-battery \
             -n -t int -s 0

xfconf-query -c xfce4-power-manager \
             -p /xfce4-power-manager/blank-on-ac \
             -n -t int -s 0

xfconf-query -c xfce4-power-manager \
             -p /xfce4-power-manager/dpms-enabled \
             -n -t 'bool' -s 'false'

xfconf-query -c xfce4-desktop \
             -p /desktop-icons/style \
             -n -t int -s 0

xfconf-query -c xfce4-desktop \
             -p /desktop-icons/show-thumbnails \
             -n -t 'bool' -s 'false'

xfconf-query -c xfwm4 \
             -p /general/show_dock_shadow \
             -n -t 'bool' -s 'false'

xfconf-query -c keyboard-layout \
             -p /Default/XkbDisable \
             -n -t 'bool' -s 'false'

xfconf-query -c keyboard-layout \
             -p /Default/XkbLayout \
             -n -t string -s 'us,hu,ro'

xfconf-query -c keyboard-layout \
             -p /Default/XkbVariant \
             -n -t string -s ',,std'

xfconf-query -c thunar \
             -p /shortcuts-icon-size \
             -n -t string -s 'THUNAR_ICON_SIZE_16'

xfconf-query -c thunar \
             -p /misc-file-size-binary \
             -n -t 'bool' -s 'false'

xfconf-query -c thunar \
             -p /misc-directory-specific-settings \
             -n -t 'bool' -s 'true'

xfconf-query -c ristretto \
             -p /window/bgcolor-override \
             -n -t 'bool' -s 'true'

xfconf-query -c ristretto \
             -p /window/bgcolor \
             -n -t double -s 0.000000 \
             -t double -s 0.000000 \
             -t double -s 0.000000 \
             -t double -s 1.000000

xfconf-query -c ristretto \
             -p /window/thumbnails/show \
             -n -t 'bool' -s 'true'

xfconf-query -c ristretto \
             -p /window/thumbnails/size \
             -n -t int -s 2

xfconf-query -c ristretto \
             -p /window/navigationbar/position \
             -n -t string -s 'bottom'

xfconf-query -c xfce4-screensaver \
             -p /saver/enabled \
             -n -t 'bool' -s 'false'

xfconf-query -c xfwm4 \
             -p /general/placement_ratio \
             -n -t int -s 100

xfconf-query -c xfwm4 \
             -p /general/mousewheel_rollup \
             -n -t 'bool' -s 'false'

xfconf-query -c xfwm4 \
             -p /general/scroll_workspaces \
             -n -t 'bool' -s 'false'

xfconf-query -c xfwm4 \
             -p /general/zoom_desktop \
             -n -t 'bool' -s 'false'

xfconf-query -c xfwm4 \
             -p /general/button_layout \
             -n -t string -s '|HMC'

xfconf-query -c xfce4-session \
             -p /general/SaveOnExit \
             -n -t 'bool' -s 'false'

xfconf-query -c xsettings \
             -p /Gtk/CursorThemeName \
             -n -t string -s 'Adwaita'

gsettings set org.xfce.mousepad.preferences.view \
          highlight-current-line true

gsettings set org.xfce.mousepad.preferences.view \
          use-default-monospace-font false

gsettings set org.xfce.mousepad.preferences.view \
          font-name 'Hack 14'