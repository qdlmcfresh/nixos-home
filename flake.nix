{
  description = "QDL's NixOS-Configuration";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablepkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    qdlpkgs.url = "github:qdlmcfresh/nixpkgs/libfprint-tod";
    secrets.url = "git+ssh://git@github.com/qdlmcfresh/nixos-secrets.git?ref=main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    leonm1-hardware.url = "github:leonm1/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    bw-key.url = "github:qdlmcfresh/bw-key";
    bw-key.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    catppuccin.url = "github:catppuccin/nix";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "stablepkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      qdlpkgs,
      stablepkgs,
      nixos-hardware,
      leonm1-hardware,
      home-manager,
      nix-vscode-extensions,
      bw-key,
      disko,
      vscode-server,
      catppuccin,
      nixos-cosmic,
      nixos-wsl,
      sops-nix,
      ghostty,
      lanzaboote,
      ...
    }:
    let
      system = "x86_64-linux";
      overlay-qdl = final: prev: {
        # use this variant if unfree packages are needed:
        qdl = import qdlpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
      overlay-stable = final: prev: {
        # use this variant if unfree packages are needed:
        stable = import stablepkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      homeConfigurations = {
        "qdl" = home-manager.lib.homeManagerConfiguration {
          # Note: I am sure this could be done better with flake-utils or something
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = inputs;
          modules = [ ./home/common/default.nix ]; # Defined later
        };
      };
      nixosConfigurations = {
        nixos-vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            vscode-server.nixosModules.default
            catppuccin.nixosModules.catppuccin
            ./hosts/nixos-vmware
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = {
                imports = [
                  ./home/graphical
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
          ];
        };
        surface-book = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            leonm1-hardware.nixosModules.microsoft-surface-common
            nixos-hardware.nixosModules.common-hidpi
            ./hosts/surface-book
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = import ./home/graphical;
            }
          ];
        };
        fuji-server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit system inputs;
            secrets = inputs.secrets.config;
          };
          modules = [
            disko.nixosModules.disko
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  overlay-qdl
                  overlay-stable
                ];
              }
            )
            ./hosts/fuji-server
            vscode-server.nixosModules.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.users.qdl = import ./home/headless;
            }
          ];
        };
        thinkbook14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  overlay-qdl
                  overlay-stable
                ];
              }

            )
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            vscode-server.nixosModules.default
            catppuccin.nixosModules.catppuccin
            nixos-cosmic.nixosModules.default
            sops-nix.nixosModules.sops
            ./hosts/thinkbook14
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.users.qdl = {
                imports = [
                  ./home/graphical
                  ./home/graphical/programs/uni.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
          ];
        };
        nixos-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.wsl
            catppuccin.nixosModules.catppuccin
            ./hosts/wsl
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = {
                imports = [
                  ./home/headless
                  ./home/headless/uni.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
          ];
        };
        desqtop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  overlay-qdl
                  overlay-stable
                ];
              }

            )
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            lanzaboote.nixosModules.lanzaboote
            (
              { pkgs, lib, ... }:
              {

                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  pkgs.sbctl
                ];

                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix
                # generated at installation time. So we force it to false
                # for now.
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            vscode-server.nixosModules.default
            catppuccin.nixosModules.catppuccin
            nixos-cosmic.nixosModules.default
            sops-nix.nixosModules.sops
            ./hosts/desqtop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.users.qdl = {
                imports = [
                  ./home/graphical
                  ./home/graphical/programs/uni.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
          ];
        };
        qdlbox = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit system inputs;
            secrets = inputs.secrets.config;
          };
          modules = [
            disko.nixosModules.disko
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  overlay-qdl
                  overlay-stable
                ];
              }
            )
            ./hosts/qdlbox
            vscode-server.nixosModules.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.users.qdl = import ./home/headless;
            }
          ];
        };
      };
    };
}
