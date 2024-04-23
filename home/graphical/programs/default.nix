{ config, pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./itsec.nix
    ./terminal.nix
    ./browser.nix
  ];
  home.packages = with pkgs; [
    remmina # remote desktop client
    zoom-us # video conferencing
    pcmanfm # file manager
    thunderbird # email client
    discord
    nextcloud-client
    gnome.file-roller # archive manager
  ];
}
