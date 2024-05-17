{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.file.".config/i3/config".source = ./config;
  home.file.".config/i3/set_background.py".source = ./set_background.py;
  programs.i3status-rust.enable = true;
  # xresources.properties = {
  #   "Xft.dpi" = 160;
  # };
}
