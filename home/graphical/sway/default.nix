{ pkgs
, config
, lib
, ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      output = {
        "Virtual-1" = {
          mode = "1920x1200@60Hz";
        };
      };
      keybindings =
        let modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec kitty";
          "${modifier}+d" = "exec rofi -show run -font Hack 13";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+e" = "exit";
        };
    };
  };
  programs = {
    swaylock = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
  };
}
