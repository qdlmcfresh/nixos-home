{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    htop
    file
    # misc
    libnotify
    xdg-utils
    graphviz

    # cloud native
    docker-compose
    distrobox
    nixpkgs-fmt

    gcc
    pkg-config
    openssl

    nix-init

    inputs.bw-key.defaultPackage.${pkgs.system}
    python3

    ente-cli
    ente-auth
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/home/qdl/.config/sops/age/keys.txt";
    secrets.ssh-hosts = { };
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
    };
    jq.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true; # set nvim as default editor
      extraConfig = ''
        set number relativenumber
      '';
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
      extraConfig = "
      Include ${config.sops.secrets.ssh-hosts.path}
      ";
    };
    git = {
      enable = true;
      userName = "qdlmcfresh";
      userEmail = "qdlmcfresh@gmail.com";
    };
  };
}
