{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/system.nix
    ../../modules/i3.nix
    ../../modules/sway.nix
    ../../modules/virt.nix
    ../../modules/steam.nix
    ../../modules/samba-mount.nix
    ./hardware-configuration.nix
    ./windows-reboot.nix
  ];

  # System, Boot, and Nix settings
  system.stateVersion = "23.05";
  nix.distributedBuilds = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking = {
    hostName = "desqtop";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  # Services
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
    displayManager = {
      defaultSession = lib.mkForce "cosmic";
    };
    desktopManager.cosmic.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;
    printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
        pkgs.brgenml1lpr
        pkgs.qdl.mfcl5750dw
      ];
      logLevel = "info";
    };
    tailscale.enable = true;
    upower.enable = true;
  };

  # Hardware, Graphics, and Audio
  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    graphics.enable32Bit = true;

  };

  security.rtkit.enable = true;

  # Desktop Environment and GUI

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-cosmic
    ];
  };

  # hardware.amdgpu.amdvlk = {
  #   enable = true;
  #   support32Bit.enable = true;
  # };

  # Environment and System Packages
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Virtualization
  virtualisation.docker.enable = true;

}
