{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jabref # bibliography manager
    papers # pdf viewer
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

}
