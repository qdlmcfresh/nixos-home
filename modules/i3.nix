{ pkgs, ... }:

{

  # i3 related options
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.gnome.gnome-keyring.enable = true;

  services.displayManager = {
    defaultSession = "none+i3";
    gdm = {
      enable = true;
    };
  };
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi # application launcher, the same as dmenu
        dunst # notification daemon
        i3blocks # status bar
        i3lock # default i3 screen locker
        xautolock # lock screen after some time
        i3status # provide information to i3bar
        i3 # i3
        picom # transparency and shadows
        feh # set wallpaper
        acpi # battery information
        arandr # screen layout manager
        dex # autostart applications
        xbindkeys # bind keys to commands
        sysstat # get system information
        nitrogen # set wallpaper
        xdg-desktop-portal-gtk
      ];
    };

    # Configure keymap in X11
    xkb.layout = "de(us)";
  };
  services.xrdp.defaultWindowManager = "i3";
}
