{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    steam-run
    steamcmd
    steam-tui
  ];
}
