#!/bin/sh

set -- \
    aisleriot \
    audacity \
    calibre \
    chromium \
    darktable \
    emacs \
    en-hunspell \
    evince-lite \
    filezilla \
    flacon \
    foliate \
    gimp \
    gnome-mahjongg \
    hu-hunspell \
    inkscape \
    isync \
    kid3-qt6 \
    libreoffice \
    lollypop \
    mu4e \
    nerd-fonts \
    obs-studio \
    ro-hunspell \
    sox \
    thunderbird \
    tigervnc-viewer \
    transmission-gtk \
    vlc \
    vscode \
    xournalpp

echo "Install packages"
for package in "$@"; do
  doas pkg install -y "$package"
done