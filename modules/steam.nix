{
  pkgs,
  ...
}:
{
  programs = {
    steam = {
      enable = true;
    };
    gamescope = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    steam-run
    protonup-ng
    lutris
    bottles
    mangohud
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
