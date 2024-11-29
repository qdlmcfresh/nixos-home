{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imhex
    ghidra-bin
    pwntools
    pwndbg
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
