# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Nethunter Kernel by GranJan
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=cepheus
device.name2=cepheus-user
device.name3=Mi 9
device.name4=Xiaomi
device.name5=
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## NetHunter additions

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel install
dump_boot;

if [ -d $ramdisk/.subackup -o -d $ramdisk/.backup ]; then
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;

# begin ramdisk changes
backup_file init.rc;
insert_line init.rc "init.nethunter.rc" after "import /init.usb.configfs.rc" "import /init.nethunter.rc";

backup_file ueventd.rc;
insert_line ueventd.rc "/dev/hidg" after "/dev/pmsg0" "/dev/hidg*                0666   root       root";
# end ramdisk changes

write_boot;
## end install

