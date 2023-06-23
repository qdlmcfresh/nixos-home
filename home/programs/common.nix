{ pkgs, ... }: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    htop

    # misc
    libnotify
    xdg-utils
    graphviz

    # cloud native
    docker-compose

    nixpkgs-fmt
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
    };
    jq.enable = true;
  };

  neovim = {
    enable = true;
    defaultEditor = true; # set nvim as default editor
    extraConfig = ''
      set number relativenumber
    '';
  };
}
