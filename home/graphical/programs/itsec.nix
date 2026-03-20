{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imhex
    ghidra
    pwntools
    picocom
    nmap
    ffuf
    zap
    sqlmap
    mycli
    gobuster
    openvpn
    winboat
  ];
}
