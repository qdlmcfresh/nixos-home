{ pkgs
, inputs
, ...
}: {
  imports = [ ../../modules/ssh ];
  networking.hostName = "nixos-wsl";
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  users.users.qdl = {
    isNormalUser = true;
    description = "qdl";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
      "surface-control"
      "dialout"
      "input"
      "lp"
      "wireshark"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  programs.ssh = {
    startAgent = true;
  };
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  environment.systemPackages = with pkgs; [
    wget
  ];
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "qdl";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };
  system.stateVersion = "24.05";
}
