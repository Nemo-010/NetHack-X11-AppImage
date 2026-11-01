#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libxaw lua54 setconf xorg-xlsfonts

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building NetHack-X11..."
echo "---------------------------------------------------------------"
mkdir -p ./AppDir/bin
VERSION=5.0.0
wget https://github.com/NetHack/NetHack/archive/refs/tags/NetHack-${VERSION}_Released.tar.gz
tar -xf ./*.tar.gz
rm -f ./*.tar.gz
cd NetHack-NetHack-${VERSION}_Released
patch -Np1 -i ../nethack-x11.patch
cd sys/unix
./setup.sh
cd ../..
make fetch-lua
make -j1 # Multi-threaded builds fail
cp sys/unix/sysconf dat/sysconf
mv -v src/nethack dat/* ../AppDir/bin
