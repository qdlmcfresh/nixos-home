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
    wofi = {
      enable = true;
    };
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          ignore_empty_input = false;
          grace = 300;
          no_fade_in = false;
          no_fade_out = false;
          pam_module = "login";
        };

        background = [{
          monitor = "";
          brightness = "0.817200";
          color = "rgba(25, 20, 20, 1.0)";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          contrast = "0.891700";
          noise = "0.011700";
          vibrancy = "0.168600";
          vibrancy_darkness = "0.050000";
        }];

        input-field = [{
          monitor = "";
          size = "600, 50";
          position = "0, -80";
          outline_thickness = 5;
          dots_center = true;
          outer_color = "rgb(24, 25, 38)";
          inner_color = "rgb(91, 96, 120)";
          font_color = "rgb(202, 211, 245)";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##cad3f5">Place your finger on the fingerprint reader ...</span>'';
          shadow_passes = 2;
          bothlock_color = -1;
          capslock_color = "-1";
          check_color = "rgb(204, 136, 34)";
          dots_rounding = "-1";
          dots_size = "0.330000";
          dots_spacing = "0.150000";
          fade_timeout = "2000";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL</i>";
          fail_transition = 300;
          halign = "center";
          hide_input = false;
          invert_numlock = false;
          numlock_color = -1;
          rounding = -1;
          shadow_boost = "1.200000";
          shadow_color = "rgba(0, 0, 0, 1.0)";
          shadow_size = 3;
          swap_font_color = false;
          valign = "center";
        }];

        image = [{
          monitor = "";
          size = 120;
          position = "0, 45";
          path = "/home/$USER/.face";
          border_color = "rgb(202, 211, 245)";
          border_size = 5;
          halign = "center";
          valign = "center";
          shadow_passes = 1;
          reload_cmd = "";
          reload_time = -1;
          rotate = "0.000000";
          rounding = "-1";
        }];

        label = [
          {
            monitor = "";
            text = ''<span font_weight="ultrabold">$TIME</span>'';
            color = "rgb(202, 211, 245)";
            font_size = 100;
            font_family = "Hack";
            valign = "center";
            halign = "center";
            position = "0, 330";
            shadow_passes = 2;
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
          }
          {
            monitor = "";
            text = ''<span font_weight="bold"> $USER</span>'';
            color = "rgb(202, 211, 245)";
            font_size = 25;
            font_family = "Hack";
            valign = "top";
            halign = "left";
            position = "10, 0";
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
            shadow_passes = 1;
          }
          {
            monitor = "";
            text = ''<span font_weight="ultrabold">󰌾 </span>'';
            color = "rgb(202, 211, 245)";
            font_size = 50;
            font_family = "Hack";
            valign = "center";
            halign = "center";
            position = "15, -350";
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
            shadow_passes = 1;
          }
          {
            monitor = "";
            text = ''<span font_weight="bold">Locked</span>'';
            color = "rgb(202, 211, 245)";
            font_size = 25;
            font_family = "Hack";
            valign = "center";
            halign = "center";
            position = "0, -430";
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
            shadow_passes = 1;
          }
          {
            monitor = "";
            text = ''
              cmd[update:120000] echo "<span font_weight='bold'>$(date +'%a %d %B')</span>"'';
            color = "rgb(202, 211, 245)";
            font_size = 30;
            font_family = "Hack";
            valign = "center";
            halign = "center";
            position = "0, 210";
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
            shadow_passes = 1;
          }
          {
            monitor = "";
            text = ''<span font_weight="ultrabold"> </span>'';
            color = "rgb(202, 211, 245)";
            font_size = 25;
            font_family = "Hack";
            valign = "bottom";
            halign = "right";
            position = "5, 8";
            rotate = "0.000000";
            shadow_boost = "1.200000";
            shadow_color = "rgba(0, 0, 0, 1.0)";
            shadow_size = 3;
            shadow_passes = 1;
          }
        ];
      };
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
