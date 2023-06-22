{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./vscode.nix
    ./common.nix
  ];
}

