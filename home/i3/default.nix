{ pkgs
, config
, lib
, ...
}:
{
  home.file.".config/i3/config".source = ./config;

  xresources.properties = {
    "Xft.dpi" = 160;
  };
}
