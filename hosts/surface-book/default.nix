{ configs, pkgs, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/leonm1/nixos-hardware.git"; }}/microsoft/surface/common"
    ../../modules/system.nix
    ../../modules/i3.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1p1";
      efiSupport = false;
      useOSProber = true;
    };
  };

  networking.hostName = "sb2";
  networking.networkmanager.enable = true;

  system.stateVersion = "23.05";
  sound.enable = true;
}
