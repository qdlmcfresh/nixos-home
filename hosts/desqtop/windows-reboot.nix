{ pkgs, ... }:
let
  windows-reboot-logic = pkgs.writeShellScriptBin "windows-reboot-logic" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail
    ${pkgs.systemd}/bin/bootctl set-oneshot auto-windows
    ${pkgs.systemd}/bin/bootctl set-timeout-oneshot 0
    ${pkgs.systemd}/bin/reboot
  '';
in
{
  environment.systemPackages = [
    windows-reboot-logic
    (pkgs.writeShellScriptBin "windows" ''
      #!${pkgs.bash}/bin/bash
      sudo ${windows-reboot-logic}/bin/windows-reboot-logic
    '')
  ];
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "${windows-reboot-logic}/bin/windows-reboot-logic";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
