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
}

