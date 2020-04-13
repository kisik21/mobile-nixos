{
  mobile-nixos
, fetchFromGitHub
, kernelPatches ? []
, buildPackages
}:

#
# Some notes:
#
#  * https://github.com/MiCode/Xiaomi_Kernel_OpenSource/wiki/How-to-compile-kernel-standalone
#
# Things to note:
#
#  * The build will not succeed using the `dtc` scripts shipped with their kernel.
#  * Will not build or boot on all compilers.
#

let
  inherit (buildPackages) dtc;
in
(mobile-nixos.kernel-builder-gcc49 {
  version = "4.4.153";
  configfile = ./config.aarch64;

  file = "Image.gz-dtb";
  hasDTB = true;

  # https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/lavender-p-oss
  src = fetchFromGitHub {
    owner = "MiCode";
    repo = "Xiaomi_Kernel_OpenSource";
    rev = "e4974f6e9478c946f99153464f93dcba498cb960";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  patches = [
    ./0001-mobile-nixos-Adds-and-sets-BGRA-as-default.patch
    ./0001-mobile-nixos-Workaround-selected-processor-does-not-.patch
    ./0003-arch-arm64-Add-config-option-to-fix-bootloader-cmdli.patch
  ] ++ kernelPatches;

  makeFlags = [
    "DTC_EXT=${dtc}/bin/dtc"
  ];

  isModular = false;

}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" "Image.gz-dtb" "install" ];
  postInstall = postInstall + ''
    cp -v "$buildRoot/arch/arm64/boot/Image.gz-dtb" "$out/"
  '';
})
