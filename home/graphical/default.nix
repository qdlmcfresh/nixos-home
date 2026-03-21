{ config, pkgs, ... }:

{

  imports = [
    ../common
    ./programs
    ./i3
    ./i3status-rust
    ./sway
    ./theming
  ];

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

  # Both of these dont work, gnome-keyring is still setting SSH_AUTH_SOCK to SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
    ];
  };
  xdg.configFile."gnome-keyring-3/daemon.ini".text = ''
    [components]
    ssh=false
  '';
}
