{pkgs, ...}: {
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
    wineWowPackages.wayland
    xdg-utils
    graphviz

    # cloud native
    docker-compose
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
    };
    jq.enable;
  };
}