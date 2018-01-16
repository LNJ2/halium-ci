#!/bin/bash

echo ********************************************
echo * Building halium image
echo * device: $HALIUM_DEVICE
echo ********************************************

echo '{"color.ui": ["auto"], "user.email": ["travis-ci@noreply.halium.org"], "user.name": ["Halium Travis-CI User"]}' > ~/.repo_.gitconfig.json

export USE_CCACHE=1

mkdir -p halium-build
cd halium-build

if ! [ -d .repo ]
then
	# init the hailum/android repos
	repo init -u https://github.com/Halium/android.git -b halium-7.1 --depth=1

	# clone halium-devices
	mkdir halium
	cd halium
	git clone https://github.com/halium/halium-devices --branch=halium-7.1 --depth=1
	cd ..
fi

# checkout all repositories for the specific device
JOBS=20 ./halium/halium-devices/setup $HALIUM_DEVICE
repo sync -c -j20 --force-sync -q

# setup for building
source build/envsetup.sh
breakfast $HALIUM_DEVICE

# compile and build everything
mka mkbootimg
mka hybris-boot
#mka systemimage

# FIXME: remove
df -h

