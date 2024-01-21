{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    steam-run
    steamPackages.steamcmd
    steam-tui
  ];
}
