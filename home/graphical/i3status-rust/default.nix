{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.file.".config/i3status-rust/config.toml".source = ./config.toml;
}
