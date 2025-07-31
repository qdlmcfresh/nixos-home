# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/system.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "qdlbox";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true; # Allow ping requests.
      allowedTCPPorts = [
        22 # SSH
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [
      ];
    };
  };

  services = {
    openiscsi = {
      enable = true;
      name = secrets.oracle_scsi_name;
      discoverPortal = secrets.oracle_scsi_portal;
    };
  };

  environment.systemPackages = with pkgs; [
    openiscsi
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AM3X0ozvKCiGAwjY5ya6oYiw87qi6y6jGF/EMlZlV"
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
