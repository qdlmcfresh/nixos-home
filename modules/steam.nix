{
  pkgs,
  ...
}:
{
  programs = {
    steam = {
      enable = true;
    };
  };
  environment.systemPackages = [
    pkgs.steam-run
    pkgs.protonup
    pkgs.lutris
    pkgs.bottles
    pkgs.mangohud
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
