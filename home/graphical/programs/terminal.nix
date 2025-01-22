{ pkgs, ghostty, ... }:
{
  programs = {
    kitty = {
      enable = true;
    };
  };
  home.packages = [
    ghostty.packages.x86_64-linux.default
  ];
}
