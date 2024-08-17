{ configs, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ../../modules/i3.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      efiSupport = false;
      useOSProber = true;
    };
  };

  networking.hostName = "nixos-vmware";
  networking.networkmanager.enable = true;

  system.stateVersion = "23.05";
  virtualisation.vmware.guest.enable = true;

  virtualisation.docker.enable = true;
  nix.settings.trusted-users = [ "nixremote" ];
  environment.systemPackages = with pkgs; [ platformio ];
  services.udev.packages = [
    pkgs.platformio
    pkgs.openocd
  ];
}
