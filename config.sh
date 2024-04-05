#!/bin/sh

echo "Install Xorg"
doas pkg install -y xorg
doas pw groupmod video -m zoliky