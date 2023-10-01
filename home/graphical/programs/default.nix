{ config
, pkgs
, ...
}:
{
  imports = [
    ./vscode.nix
    ./itsec.nix
    ./terminal.nix
    ./browser.nix
  ];
  home.packages = with pkgs; [
    remmina # remote desktop client
  ];
}

