{ configs, pkgs, ... }:

{
  imports = [
    #"${builtins.fetchGit { url = "https://github.com/leonm1/nixos-hardware.git"; }}/microsoft/surface/common"
    ../../modules/system.nix
    ../../modules/i3.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sb2";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "23.05";

  nix.buildMachines = [{
    hostName = "nixos-vmware";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    # if the builder supports building for multiple architectures,
    # replace the previous line by, e.g.,
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;

  services.printing.enable = true;

  services.xserver.dpi = 180;
  services.xserver.videoDrivers = [ "intel" ];
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    xorg.xf86videointel
    xorg.xbacklight
  ];
  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };

  microsoft-surface.surface-control.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.upower.enable = true;
}
