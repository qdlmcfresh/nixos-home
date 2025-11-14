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

  systemd.user.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
  # Force the gnome-keyring ssh socket path to point to the bitwarden agent socket.
  systemd.user.services.link-ssh-auth-sock = {
    Unit = {
      Description = "Link Bitwarden SSH agent socket to gnome-keyring path";
      Before = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart =
        let
          script = pkgs.writeShellScript "link-ssh-sock.sh" ''
            mkdir -p /run/user/$(${pkgs.coreutils}/bin/id -u)/keyring
            ${pkgs.coreutils}/bin/ln -sf "$HOME/.bitwarden-ssh-agent.sock" /run/user/$(${pkgs.coreutils}/bin/id -u)/keyring/ssh
          '';
        in
        "${script}";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
