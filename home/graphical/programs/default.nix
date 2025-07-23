{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./itsec.nix
    ./terminal.nix
    ./browser.nix
    ./distrobox.nix
  ];
  home.packages = with pkgs; [
    remmina # remote desktop client
    zoom-us # video conferencing
    pcmanfm # file manager
    thunderbird # email client
    discord
    nextcloud-client
    file-roller # archive manager
    scrcpy # android screen mirroring
    signal-desktop-bin # messaging
    element-desktop # messaging
    obs-studio # screen recording
    v4l-utils # video for linux utilities
    spotify # music
    easyeffects # audio effects, mic noise reduction
    rustdesk # remote desktop
  ];
}
