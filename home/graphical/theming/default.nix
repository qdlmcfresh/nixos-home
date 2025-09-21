#
#  GTK
#

{
  pkgs,
  catppuccin,
  home-manager,
  config,
  lib,
  ...
}:

{
  xdg = {
    enable = true;
  };
  catppuccin = {
    enable = true;
    #flavour = "mocha";
    flavor = "mocha";
    waybar.enable = lib.mkForce false;
    mako.enable = false;
  };
  home = {
    pointerCursor = {
      # System-Wide Cursor
      gtk.enable = true;
      #name = "Dracula-cursors";
      name = lib.mkDefault "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = lib.mkDefault pkgs.catppuccin-cursors.mochaDark;
      size = lib.mkDefault 16;
    };
  };
  gtk = {
    # Theming
    enable = true;
    #catppuccin.enable = true;
    # theme = {
    #   #name = "Dracula";
    #   name = "Catppuccin-Mocha-Compact-Blue-Dark";
    #   #package = pkgs.dracula-theme;
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = [ "blue" ];
    #     size = "compact";
    #     variant = "mocha";
    #   };
    # };
    iconTheme = lib.mkDefault {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Hack";
    };
  };
}
