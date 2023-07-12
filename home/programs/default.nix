{ config
, pkgs
, ...
}:
{
  imports = [
    ./vscode.nix
    ./common.nix
    ./shell.nix
    ./itsec.nix
  ];
}

