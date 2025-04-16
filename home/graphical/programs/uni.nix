{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jabref # bibliography manager
    papers # pdf viewer
  ];
}
