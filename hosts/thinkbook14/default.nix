{
  configs,
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
    ../../modules/samba-mount.nix
    ../../modules/bitwarden.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkbook14";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "23.05";

  nix.buildMachines = [
    {
      hostName = "nixos-vmware";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.,
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];
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
  services.displayManager.defaultSession = lib.mkForce "cosmic";

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    xorg.xbacklight
  ];
  services.fprintd = {
    enable = true;
    package = pkgs.qdl.fprintd-tod;
    tod.enable = true;
    tod.driver = pkgs.qdl.libfprint-2-tod1-elan;
  };

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
  powerManagement.powertop.enable = true;
  # services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # services.logind.lidSwitchExternalPower = "ignore";
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  services.desktopManager.cosmic.enable = true;
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      wlr.enable = true;
      wlr.settings.screencast = {
        output_name = "eDP-1";
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-cosmic
      ];
    };
  };
  # services.displayManager.cosmic-greeter.enable = true;
  virtualisation.waydroid.enable = true;
}
