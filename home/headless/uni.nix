{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quarto # scientific and technical publishing
  ];
}