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
  ];

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desqtop";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "23.05";

  nix.distributedBuilds = true;

  services.displayManager.defaultSession = lib.mkForce "cosmic";

  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.qdl.mfcl5750dw
    ];
    logLevel = "info";
  };

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };

  virtualisation.docker.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.tailscale = {
    enable = true;
  };

  services.blueman.enable = true;
  services.upower.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  services.desktopManager.cosmic.enable = true;
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-cosmic
      ];
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # amdgpu.amdvlk = {
    #   enable = true;
    #   support32Bit.enable = true;
    # };
    bluetooth.enable = true;
  };
}
