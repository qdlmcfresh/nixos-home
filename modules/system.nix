{
  config,
  pkgs,
  sops-nix,
  vscode-server,
  inputs,
  ...
}:

{
  imports = [
    ./ssh
  ];
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
    options = "--delete-older-than 5d";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      #PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
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
    pciutils
    usbutils
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

  services.vscode-server.enable = true;
  services.gvfs.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.fira-code
    font-awesome
  ];

  home-manager.backupFileExtension = ".bak";

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/home/qdl/.ssh/id_ed25519"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "test-secret" = { };
      "openvpn/hs-openvpn-config" = {
        path = "/home/qdl/.config/openvpn/hs.ovpn";
        owner = config.users.users.qdl.name;
      };
      "openvpn/login.conf" = {
        path = "/home/qdl/.config/openvpn/login.conf";
        owner = config.users.users.qdl.name;
      };
      ssh-hosts = {
        owner = config.users.users.qdl.name;
      };
    };
  };
}
