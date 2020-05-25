#!/bin/bash
rm .version

clear
cd ~/QK-AOSP-Cepheus/

# Resources
THREAD="$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image.gz-dtb"
DTBIMAGE="dtb"
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=~/toolchains/Clang-11/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${HOME}/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/daniel/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export CONFIG_CROSS_COMPILE_COMPAT_VDSO="arm-linux-gnueabihf-"
export CXXFLAGS="$CXXFLAGS -fPIC"
export LOCALVERSION=-NetHunter


DEFCONFIG="cepheus_nethunter_defconfig"

# Paths
KERNEL_DIR=`pwd`
ZIMAGE_DIR="${HOME}/QK-AOSP-Cepheus/out-clang/arch/arm64/boot/"
zm="${HOME}/QK-AOSP-Cepheus/out-clang/modules_out/"
mkdir $zm

DATE_START=$(date +"%s")

echo "-------------------"
echo "Making Kernel:"
echo "-------------------"

echo
make CC=clang O=out-clang $DEFCONFIG
make CC=clang O=out-clang $THREAD 2>&1 | tee kernel.log
#INSTALL_MOD_PATH=$zm $THREAD modules_install

echo "-------------------"
echo "Build Completed in:"
echo "-------------------"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
cd $ZIMAGE_DIR
ls -a

rm -rf ~/MI9_Anykernel3_Nethunter/Image*
rm -rf ~/MI9_Anykernel3_Nethunter/dtbo.img
#rm -rf ~/out_kernel_asop/nethunter*
cp -a ~/QK-AOSP-Cepheus/out-clang/arch/arm64/boot/Image.gz-dtb ~/MI9_Anykernel3_Nethunter

cd ~/MI9_Anykernel3_Nethunter
rm release/*.zip 2>/dev/null
zip -r9 release/nethunter_asop_kernel_qk-1.4.zip * -x .git README.md *placeholder release/
