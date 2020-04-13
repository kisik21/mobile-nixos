{ config, lib, pkgs, ... }:

{
  mobile.device.name = "xiaomi-laurel_sprout";
  mobile.device.info = rec {
    # TODO : make kernel part of options.
    kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
    format_version = "0";
    name = "Xiaomi Mi A3";
    manufacturer = "Xiaomi";
    codename = "xiaomi-laurel_sprout";
    modules_initfs = "";
    arch = "aarch64";
    keyboard = "false";
    external_storage = "true";
    screen_width = "720";
    screen_height = "1560";
    flash_method = "fastboot";
    kernel_cmdline = lib.concatStringsSep " " [
      "rcupdate.rcu_expedited=1"
      "rcu_nocbs=0-7"
      "console=ttyMSM0,115200n8"
      "androidboot.hardware=qcom"
      "androidboot.console=ttyMSM0"
      "androidboot.memcg=1"
      "lpm_levels.sleep_disabled=1"
      "video=vfb:640x400,bpp=32,memsize=3072000"
      "msm_rtb.filter=0x237"
      "service_locator.enable=1"
      "swiotlb=1"
      "earlycon=msm_geni_serial,0x4a90000"
      "loop.max_part=7"
      "cgroup.memory=nokmem,nosocket"
      "buildvariant=userdebug"
      "androidboot.keymaster=1"
      "androidboot.bootdevice=4804000.ufshc"
      "androidboot.serialno=4d37a77c1ab1"
      "androidboot.hwversion=10.39.0"
      "androidboot.hwlevel=MP"
      "androidboot.hwc=Global28"
      "androidboot.baseband=msm"
      "msm_drm.dsi_display0=dsi_s6e8fco_samsung_hdp_video_display:"
      "rootwait"
      "ro"
      "init=/init"
      "androidboot.dtbo_idx=0"
    ];
    generate_bootimg = "true";
    bootimg_qcdt = false;
    flash_offset_base = "0x00000000";
    flash_offset_kernel = "0x00008000";
    flash_offset_ramdisk = "0x01000000";
    flash_offset_second = "0x00f00000";
    flash_offset_tags = "0x00000100";
    flash_pagesize = "4096";

    # This device adds skip_initramfs to cmdline for normal boots
    boot_as_recovery = true;

    vendor_partition = "/dev/disk/by-partlabel/vendor";
    gadgetfs.functions = {
      rndis = "rndis_bam.rndis";
      # FIXME: This is likely the right function name, but doesn't work.
      # adb = "ffs.usb0";
    };
  };
  mobile.hardware = {
    soc = "qualcomm-sdm665";
    ram = 1024 * 4;
    screen = {
      width = 720; height = 1650;
    };
  };

  mobile.usb.mode = "gadgetfs";
  # FIXME: attribute to sources.
  mobile.usb.idVendor  = "2717"; # Xiaomi Communications Co., Ltd.
  mobile.usb.idProduct = "FF80"; # Mi/Redmi series (RNDIS)

  mobile.system.type = "android";
}
