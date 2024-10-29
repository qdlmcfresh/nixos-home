{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jabref # bibliography manager
    quarto # scientific and technical publishing
  ];
}