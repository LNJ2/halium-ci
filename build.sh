#!/bin/bash

echo ********************************************
echo * Building halium image
echo * device: $HALIUM_DEVICE
echo ********************************************

echo '{"color.ui": ["auto"], "user.email": ["travis-ci@noreply.halium.org"], "user.name": ["Halium Travis-CI User"]}' > ~/.repo_.gitconfig.json

export USE_CCACHE=1

mkdir build
cd build

# init the hailum/android repos
repo init -u https://github.com/Halium/android.git -b halium-7.1 --depth=1

# clone halium-devices
mkdir halium
cd halium
git clone https://github.com/halium/halium-devices --branch=halium-7.1 --depth=1
cd ..

JOBS=25 ./halium/halium-devices/setup $HALIUM_DEVICE

# setup for building
source build/envsetup.sh
breakfast $HALIUM_DEVICE

# compile and build everything
mka mkbootimg
mka hybris-boot
mka systemimage

