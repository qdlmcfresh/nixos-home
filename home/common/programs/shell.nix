{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      [[ $(builtin bindkey "^[[1;5C") == *" undefined-key" ]] && builtin bindkey "^[[1;5C" "forward-word"
      [[ $(builtin bindkey "^[[1;5D") == *" undefined-key" ]] && builtin bindkey "^[[1;5D" "backward-word"
    '';
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos-home#$(hostname)";
      loadsshkeys = "bw-key --host https://vault.qdlbox.de --name qdlmcfresh@gmail.com --method yubikey";
      loadsshkeys-auth = "bw-key --host https://vault.qdlbox.de --name qdlmcfresh@gmail.com --method auth";
      ssh = "TERM=xterm-256color ssh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    plugins = [
      {
        name = "H-S-MW";
        src = pkgs.fetchFromGitHub {
          owner = "z-shell";
          repo = "H-S-MW";
          rev = "v1.0.0";
          sha256 = "1d8yg38d2b9dd331yrdp8lj5qr6winr2vmdnc54c7nn8hz4n341n";
        };
      }
    ];
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
  };
}
