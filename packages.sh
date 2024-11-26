#!/bin/sh

set -- \
    aisleriot \
    audacity \
    calibre \
    chromium \
    coreutils \
    darktable \
    emacs \
    en-hunspell \
    evince-lite \
    filezilla \
    flacon \
    foliate \
    gimp \
    gnome-mahjongg \
    go \
    gohugo \
    hu-hunspell \
    inkscape \
    isync \
    kid3-qt6 \
    libreoffice \
    lollypop \
    mu4e \
    nerd-fonts \
    node \
    obs-studio \
    python3 \
    ro-hunspell \
    ruby \
    sox \
    tex-xetex \
    texstudio \
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