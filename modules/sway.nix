{ pkgs, lib, ... }:
{
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
  services.xserver.displayManager.defaultSession = lib.mkForce "sway";
  environment.systemPackages = with pkgs; [
    brightnessctl
    swaybg
    wmname
    wdisplays
    wl-mirror
  ];
}
