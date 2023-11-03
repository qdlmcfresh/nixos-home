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
          "${modifier}+Shift+e" = "mode exit";
          "${modifier}+Shift+r" = "reload";
          "XF86AudioRaiseVolume" = "exec amixer sset Master '5%+'";
          "XF86AudioLowerVolume" = "exec amixer sset Master '5%-'";
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "de(us)";
        };
      };
      bars = [
        {
          position = "top";
          command = "waybar";
        }
      ];
      window = {
        titlebar = false;
        border = 2;
      };
      modes = lib.mkOptionDefault {
        exit = {
          "k" = "exec swaylock -f -c 000000";
          "l" = "exit";
          "u" = "exec systemctl suspend";
          "h" = "exec systemctl hibernate";
          "r" = "exec systemctl reboot";
          "s" = "exec systemctl poweroff";
          "Escape" = "mode default";
        };
      };
    };
    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export _JAVA_AWT_WM_NONREPARENTING=1

    ''; #      wmname LG3D
    # wmname is needed for Java Swing applications
  };
  programs = {
    swaylock = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
    wofi = {
      enable = true;
    };
  };
}
