{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_6_1;
    kernel.sysctl = { "vm.swappiness" = 50; };
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback.out ];
  };
}
