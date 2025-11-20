#!/bin/sh

set -eu

ARCH=$(uname -m)


echo "Initialisation de la clé pacman..."
echo "---------------------------------------------------------------"
pacman-key --init
pacman-key --populate

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
            xorg-server-xvfb \ 
            xorg-xvfb-run \
            curl \
            wget\
            pika-backup 
            

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
