{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.bitwarden-desktop
  ];

  programs.ssh.startAgent = lib.mkForce false;

  environment.variables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };

  systemd.user.services.bitwarden-desktop = {
    description = "Bitwarden Desktop";
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden-desktop";
      Type = "oneshot";
    };
  };
}
