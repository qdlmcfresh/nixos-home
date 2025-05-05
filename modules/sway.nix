{
  pkgs,
  lib,
  host,
  ...
}:
{
  services.displayManager.sessionPackages = [ pkgs.sway ];
  services.displayManager.defaultSession = lib.mkForce "sway";
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
    #stable.waybar
  ];
  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = {
    text = "auth include system-auth";
    fprintAuth = if host.hostName == "thinkbook14" then true else false;
  };
}
