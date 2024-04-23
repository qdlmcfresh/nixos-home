{
  pkgs,
  config,
  lib,
  ...
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
      startup = [
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
        { command = "swaync"; }
        { command = "wmname LG3D"; }
      ];
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec kitty";
          "${modifier}+d" = "exec rofi -show run -font Hack 13";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+e" = "mode exit";
          "${modifier}+Shift+r" = "reload";
          "${modifier}+Shift+s" = "exec wayshot -s \"$(slurp)\" --stdout | wl-copy";
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
    ''; # wmname LG3D
    # wmname is needed for Java Swing applications
  };
  home.file.".config/waybar/config".source = ./waybar_config;
  programs = {
    swaylock = {
      enable = true;
    };
    # waybar = {
    #   enable = true;
    # };
    wofi = {
      enable = true;
    };
    hyprlock = {
      enable = true;
      general = {
        hide_cursor = true;
        no_fade_in = false;
        disable_loading_bar = true;
        grace = 0;
      };
      backgrounds = [
        {
          monitor = "";
          #path = ".config/wall.png";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 1;
          blur_size = 0;
          brightness = 0.2;
        }
      ];
      input-fields = [
        {
          monitor = "";
          size = {
            width = 250;
            height = 60;
          };
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
          hide_input = false;
          position = {
            x = 0;
            y = -120;
          };
          halign = "center";
          valign = "center";
        }
      ];
      labels = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 120;
          position = {
            x = 0;
            y = 250;
          };
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] /run/current-system/sw/bin/echo "<span>$(/run/current-system/sw/bin/date)</span>"
          '';
          font_size = 40;
          position = {
            x = 0;
            y = 120;
          };
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "Unlock with fingerprint";
          font_size = 20;
          position = {
            x = 0;
            y = 80;
          };
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "$FAIL $ATTEMPTS";
          font_size = 20;
          position = {
            x = 0;
            y = 50;
          };
          valign = "center";
          halign = "center";
        }
      ];
    };
  };
  services = {
    swayidle = {
      enable = true;
      systemdTarget = "sway-session.target";
      timeouts = [
        {
          timeout = 120;
          command = "/run/current-system/sw/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.hyprlock}/bin/hyprlock";
        }
      ];
    };
  };
}
