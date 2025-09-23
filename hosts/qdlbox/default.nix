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
        465 # SMTP
        587 # SMTP
        993 # IMAPS
        25 # SMTP
        27896 # headscale
      ];
      allowedUDPPorts = [
        51820 # WireGuard
      ];
      interfaces = {
        "br-79dfcc5f0154" = {
          allowedTCPPorts = [
            3443
          ];
        };
      };
    };
  };

  services = {
    openiscsi = {
      enable = true;
      name = secrets.oracle_scsi_name;
      discoverPortal = secrets.oracle_scsi_portal;
      enableAutoLoginOut = true;
    };
    vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      config = with secrets;{
        DOMAIN = vw_domain;
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = 3443;
        WEBSOCKET_ENABLED = true;
        SIGNUPS_ALLOWED = false;
        ADMIN_TOKEN = vw_admin_token;
        YUBICO_CLIENT_ID = vw_yubico_client_id;
        YUBICO_SECRET_KEY = vw_yubico_secret_key;
        SMTP_HOST = "smtp-relay.brevo.com";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 587;
        SMTP_FROM = vw_smtp_from;
        SMTP_FROM_NAME = vw_smtp_from_name;
        SMTP_USERNAME = brevo_smtp_user;
        SMTP_PASSWORD = brevo_smtp_password;
        SMTP_AUTH_MECHANISM="Login";
      };
      backupDir = "/block/vaultwarden_backup";
    };
  };

  fileSystems."/block" = {
    device = "/dev/sdb1";
    fsType = "ext4";
    options = [
      "_netdev"
      "nofail"
    ];
  };

  environment.systemPackages = with pkgs; [
    openiscsi
  ];

  virtualisation.docker.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AM3X0ozvKCiGAwjY5ya6oYiw87qi6y6jGF/EMlZlV"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNt6LK0SdLFoGbR7hY0X92URM1Df1tO/wGGGComRmrW"
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
