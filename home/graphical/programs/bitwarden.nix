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
      match = ''host * exec "test -S ${config.home.homeDirectory}/.bitwarden-ssh-agent.sock"'';
      extraOptions = {
        IdentityAgent = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
      };
    };
  };

  # Note: Home Manager's systemd syntax strictly uses Unit, Service, and Install attribute sets
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
