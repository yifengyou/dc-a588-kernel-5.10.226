#!/bin/bash

set -ex

JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`
ARCH=`uname -m`
export KERNEL_TARGET=d3588

if [ X"${ARCH}" == X"aarch64" ] ; then
	GCC=""
	CROSS_COMPILE_ARM64=""
elif [ X"${ARCH}" == X"x86_64" ] ; then
	GCC=`realpath ../gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu`
	CROSS_COMPILE_ARM64=${GCC}/bin/aarch64-none-linux-gnu-
else
	echo "${ARCH} is not supported now!"
	exit 1
fi

# kernel
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE_ARM64} ${KERNEL_TARGET}_defconfig
make ARCH=arm64 menuconfig
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE_ARM64} -j$JOB

mkdir -p ../tools/
cp arch/arm64/boot/Image ../tools/

echo "All done! [$?]"

