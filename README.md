# nethunter
run setup to dowload the toolchains after that cd in to
~/Quantic-Kernel-AOSP-Cepheus
after that run chmod +x and the ./build.sh to start the build
After some time you will have a kernel hopefully
After it completes you will have to pack the kernel with Anykernel3,the buildscript will do that for you.

I prefere to download a copy of the latest Quantic kernel and then put in a folder MI9_Anykernel3_Nethunter
remember to put in anykernl.sh nethunterbits otherwis Hid won't work
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
backup_file init.rc;
insert_line init.rc "init.nethunter.rc" after "import /init.usb.configfs.rc" "import /init.nethunter.rc";
backup_file ueventd.rc;
insert_line ueventd.rc "/dev/hidg" after "/dev/pmsg0" "/dev/hidg*                0666   root       root";


unzip the zip file and then replace the Image.gz-dtb found in Quantic-Kernel-AOSP-Cepheus/out-clang/arch/arm64/boot/
add the nethuner stuff to anykernel.sh then zip the file 
zip -r9 release/nethunter_asop_kernel.zip * -x .git README.md *placeholder release/

when it's finished copy release/nethunter_asop_kernel.zip to your phone for test remember to back upp kernel  before you flash!

If the kernel work as aspected then we can add the nethunter stuff copy the patches form patch folder to your kernel source
if you are brave applay all the patches at the same time and compile the kernel again.it's eaisier to apply one at the time 
to apply the patches typ patch -p1 < nameofhtepatch.patch
