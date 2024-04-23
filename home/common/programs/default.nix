{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ./shell.nix
    ./rust.nix
  ];
}
