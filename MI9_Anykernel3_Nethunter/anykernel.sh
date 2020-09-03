# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=cepheus
device.name2=Mi9

supported.versions=
'; } # end properties
ui_print "Quantic Kernel installer v3.0 by Ayrton990@XDA";
# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# Set Android version for kernel
ver="$(file_getprop /system/build.prop ro.build.version.release)"
if [ ! -z "$ver" ]; then
  patch_cmdline "androidboot.version" "androidboot.version=$ver"
else
  patch_cmdline "androidboot.version" ""
fi

# Set display timing mode based on ZIP file name
case "$ZIPFILE" in
*66fps*|*66hz*)
    ui_print "  • Setting 66 Hz refresh rate"
    patch_cmdline "msm_drm.timing_override" "msm_drm.timing_override=1"
	patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=1"
    ;;
  *)
    ui_print "  • Setting 60 Hz refresh rate"
    patch_cmdline "msm_drm.timing_override" ""
    fr=$(cat /sdcard/framerate_override | tr -cd "[0-9]");
    [ $fr -eq 66 ] && ui_print "  • Setting 66 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=1"
	;;
esac

echo "  • Optimizing f2fs"
mkdir -p /mnt
mount /dev/block/bootdevice/by-name/userdata /mnt

find /sys/fs/f2fs* -name extension_list | while read list; do
  echo "  • Updating extensions list for $list"

  echo "  • Removing previous extensions list"

  HOT=$(cat $list | grep -n 'hot file extension' | cut -d : -f 1)
  COLD=$(($(cat $list | wc -l) - $HOT))

  COLDLIST=$(head -n$(($HOT - 1)) $list | grep -v ':')
  HOTLIST=$(tail -n$COLD $list)

  echo $COLDLIST | tr ' ' '\n' | while read cold; do
    echo "[c]!$cold"
    echo "[c]!$cold" > $list
  done

  echo $HOTLIST | tr ' ' '\n' | while read hot; do
    echo "[h]!$hot"
    echo "[h]!$hot" > $list
  done

  echo "  • Writing new extensions list"

  cat /sbin/f2fs-cold.list | grep -v '#' | while read cold; do
    if [ ! -z $cold ]; then
      echo "[c]$cold"
      echo "[c]$cold" > $list
    fi
  done

  cat /sbin/f2fs-hot.list | while read hot; do
    if [ ! -z $hot ]; then
      echo "[h]$hot"
      echo "[h]$hot" > $list
    fi
  done
done

umount /mnt

decomp_image=$home/Image
comp_image=$decomp_image.gz

# Hex-patch the kernel if Magisk is NOT installed ('want_initramfs' -> 'skip_initramfs')
# This negates the need to reflash Magisk and makes flashing quicker for Magisk users
if [ -f $comp_image ]; then
  comp_rd=$split_img/ramdisk.cpio
  decomp_rd=$home/_ramdisk.cpio
  $bin/magiskboot decompress $comp_rd $decomp_rd || cp $comp_rd $decomp_rd

  if ! $bin/magiskboot cpio $decomp_rd "exists .backup"; then
    $bin/magiskboot decompress $comp_image $decomp_image;
    $bin/magiskboot hexpatch $decomp_image  736B69705F696E697472616D667300 77616E745F696E697472616D667300;
    $bin/magiskboot compress=gzip $decomp_image $comp_image;
  else
    ui_print "  • Preserving Magisk";
  fi;

  # Concatenate all DTBs to the kernel
  cat $comp_image $home/dtbs/*.dtb > $comp_image-dtb;
  rm -f $decomp_image $comp_image
fi;

# Set MQ scheduler
# patch_cmdline "scsi_mod.use_blk_mq=1";
# patch_cmdline "scsi_mod.use_blk_mq=0";
# ui_print "  • Enabling MQ-Schedulers"


# end ramdisk changes

write_boot;
## end install
