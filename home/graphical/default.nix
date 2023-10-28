{ config, pkgs, ... }:

{

  imports = [
    ../common
    ./programs
    ./i3
    ./i3status-rust
    ./sway
  ];

  home.file."Wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
