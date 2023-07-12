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

    #browser
    firefox

    #rust
    rustc
    cargo
    gcc
    pkg-config
    openssl

    bw-key.defaultPackage.${pkgs.system}
  ];

  programs = {
    kitty = {
      enable = true;
    };
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
  };
}
