{ pkgs, inputs, ... }:
{
  programs = {
    kitty = {
      enable = true;
    };
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      systemd = {
        enable = true;
      };
    };
  };
}
