{ pkgs, bw-key, ... }: {
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

    nixpkgs-fmt

    gcc
    pkg-config
    openssl

    nix-init

    bw-key.defaultPackage.${pkgs.system}
  ];

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
    ssh.forwardAgent = true;
    git = {
      enable = true;
      userName = "qdlmcfresh";
      userEmail = "qdlmcfresh@gmail.com";
    };
  };
}
