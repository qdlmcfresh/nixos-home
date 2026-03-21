{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.stable.bitwarden-desktop
  ];

  programs.ssh.matchBlocks = {
    "*" = {
      forwardAgent = true;
    };
    "bitwarden-agent" = {
      # 1. test -z "$SSH_CONNECTION": Ensure we are NOT currently inside an SSH session
      # 2. test -S /path/to/socket: Ensure the Bitwarden socket file actually exists
      match = ''host * exec "test -z \"$SSH_CONNECTION\" && test -S ${config.home.homeDirectory}/.bitwarden-ssh-agent.sock"'';
      extraOptions = {
        IdentityAgent = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
      };
    };
  };

  systemd.user.services.bitwarden-desktop = {
    Unit = {
      Description = "Bitwarden Desktop";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden";
      Type = "simple";
    };
  };
}
