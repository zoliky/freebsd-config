#!/bin/sh

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
             -n -t 'bool' -s 'false'

xfconf-query -c ristretto \
             -p /window/thumbnails/size \
             -n -t int -s 2

xfconf-query -c ristretto \
             -p /window/navigationbar/position \
             -n -t string -s 'bottom'