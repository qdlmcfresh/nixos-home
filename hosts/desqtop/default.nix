{
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/system.nix
    ../../modules/i3.nix
    ../../modules/sway.nix
    ../../modules/virt.nix
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

  hardware = {
    graphics.enable = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
    bluetooth.enable = true;
  };

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
  # services.logind.lidSwitchExternalPower = "ignore";
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
}
