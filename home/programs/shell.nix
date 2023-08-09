{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      [[ $(builtin bindkey "^[[1;5C") == *" undefined-key" ]] && builtin bindkey "^[[1;5C" "forward-word"
      [[ $(builtin bindkey "^[[1;5D") == *" undefined-key" ]] && builtin bindkey "^[[1;5D" "backward-word"
    '';
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/nixos-home#nixos-vmware";
      loadsshkeys = "bw-key --host https://vault.qdlbox.de --name qdlmcfresh@gmail.com --method yubikey";
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
}
