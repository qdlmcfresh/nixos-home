{ config, pkgs, ... }:


{
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      #PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    sysstat
    # minimal screen capture tool, used by i3 blur lock to take a screenshot
    # print screen key is also bound to this tool in i3 config
    scrot
    neofetch
    pavucontrol
    python3
  ];

  security.polkit.enable = true;
  programs.zsh.enable = true;
  programs.ssh = {
    startAgent = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qdl = {
    isNormalUser = true;
    description = "qdl";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGvUpLK6QzRtX5FHfdLrt37cQZcGFXmOmkQmWOv5YH7irOVVpj+/MeN6KWziTGPvdYmq1SOVbYnCrEoCgSlChE4ZUt9DFcpPhgKDzkVZVK2y25EEVEnxO2p64J0OtTt54rl3ODvzc0a5wSI5aVJSGaVVtaUWlwRESs3DdD9Y0XxmpW2vxP+z7SOrNFQqfGLOXp9PXu3BPF6G6ZeGxu5fBhoiInX6dKf3NvLYwaT9ZXy0Ur279LowCw4R9kMDzNb4KPJcC7Q04VsFtzyf83uxOmpFwFOWfXKIWd+/8RdfjJrVR+7SWXiuH4x9Fsb0ofmis7vg7sud1Hp/xI/ZRbk6W3" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
  ];

}
