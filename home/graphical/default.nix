{ config, pkgs, ... }:

{

  imports = [
    ../common
    ./programs
    ./i3
    ./i3status-rust
  ];
}
