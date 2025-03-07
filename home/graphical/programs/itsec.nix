{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imhex
    ghidra-bin
    pwntools
    picocom
    nmap
    ffuf
    zap
    sqlmap
    mycli
    gobuster
    openvpn
  ];
}
