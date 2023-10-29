{ config, pkgs, ... }:

{

  imports = [
    ../common
    ./programs
    ./i3
    ./i3status-rust
  ];

  users.users.qdl.extraGroups = [ "libvirtd" ];
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.file."Wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
