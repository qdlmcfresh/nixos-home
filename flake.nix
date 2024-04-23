{
  description = "QDL's NixOS-Configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablepkgs.url = "github:leona-ya/nixpkgs/paperless-subpath";
    qdlpkgs.url = "github:qdlmcfresh/nixpkgs/brother_mfc_L5750DW";
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
    hyprlock.url = "github:hyprwm/hyprlock";
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , qdlpkgs
    , stablepkgs
    , nixos-hardware
    , leonm1-hardware
    , home-manager
    , nix-vscode-extensions
    , bw-key
    , disko
    , vscode-server
    , hyprlock
    , catppuccin
    , ...
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
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        nixos-vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            vscode-server.nixosModules.default
            ./hosts/nixos-vmware
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = import ./home/graphical;
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
          modules = [
            disko.nixosModules.disko
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-qdl overlay-stable ]; })
            ./hosts/fuji-server
            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = import ./home/headless;
            }
          ];
        };
        thinkbook14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-qdl overlay-stable ]; })
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            ./hosts/thinkbook14
            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = {
                imports = [
                  ./home/graphical
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
      };
    };
}
