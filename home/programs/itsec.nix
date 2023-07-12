{ pkgs, ... }: {
  home.packages = with pkgs; [
    imhex
    ghidra-bin
    wireshark
    pwntools
    pwndbg
  ];
}
