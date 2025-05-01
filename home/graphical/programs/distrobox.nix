{ pkgs, config, ... }:
{
  home.packages = [ pkgs.distrobox ];

  xdg.configFile = {
    "distrobox/distrobox.conf".text = ''
      container_always_pull="1"
      container_generate_entry=1
    '';
    "distrobox/distrobox.ini" = {
      text = pkgs.lib.generators.toINI { } {
        kali = {
          image = "kalilinux/kali-rolling";
          additional_packages = "kali-linux-headless ghidra firefox-esr gdb make curl git neovim";
          init_hooks = ''
            bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
          '';
          pull = true;
          root = false;
          replace = true;
          home = "/var/distrobox_homes/kali/";
          exported_apps = "firefox";
        };
      };
      onChange = # bash
        let
          # Use the actual path in the home directory
          configFileDest = "${config.xdg.configHome}/distrobox/distrobox.ini";
        in
        ''
          export PATH=${pkgs.docker}/bin:$PATH
          ${pkgs.distrobox}/bin/distrobox assemble create --file "${configFileDest}"
        '';
    };
  };
}
