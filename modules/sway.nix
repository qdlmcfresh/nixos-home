{
  pkgs,
  lib,
  host,
  ...
}:
{
  services.displayManager.sessionPackages = [ pkgs.sway ];
  services.displayManager.defaultSession = lib.mkForce "sway";
  xdg.portal.config.common.default = "*";
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
  ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    swaybg
    wmname
    wdisplays
    wl-mirror
    swaynotificationcenter
    swayidle
    slurp
    wayshot
    wl-clipboard
    wayvnc
    stable.wireplumber
    stable.waybar
  ];
  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = {
    text = "auth include system-auth";
    fprintAuth = if host.hostName == "thinkbook14" then true else false;
  };
}
