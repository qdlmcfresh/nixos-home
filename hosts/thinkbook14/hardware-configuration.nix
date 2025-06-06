# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "v4l2loopback"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f8a2bb09-68bd-45ce-beda-1c21fe82fc30";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/175B-C9A9";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  #networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.enableAllFirmware = lib.mkForce true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.firewall.checkReversePath = false; # for wireguard
  networking.useDHCP = false;
  networking.bridges."br-lan".interfaces = [ "enp0s31f6" ];
  networking.bridges."br-lan".rstp = true;
  networking.interfaces."br-lan".useDHCP = true;
  networking.interfaces."wlp0s20f3".useDHCP = true;
  boot.initrd.systemd.network.wait-online.ignoredInterfaces = [
    "enp0s31f6"
    "br-lan"
  ];
  networking.networkmanager.unmanaged = [
    "br-lan"
    "enp0s31f6"
  ];
}
