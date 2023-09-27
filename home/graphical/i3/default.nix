{ pkgs
, config
, lib
, ...
}:
{
  home.file.".config/i3/config".source = ./config;
  programs.i3status-rust.enable = true;
  # xresources.properties = {
  #   "Xft.dpi" = 160;
  # };
}
