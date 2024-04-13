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