{ pkgs, bw-key, ... }: {
  home.packages = with pkgs; [
    firefox
    chromium
  ];
}
