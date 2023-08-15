{
  description = "QDL's NixOS-Configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:leonm1/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    bw-key.url = "github:qdlmcfresh/bw-key";
    bw-key.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nix-vscode-extensions, bw-key, ... }:
    {
      nixosConfigurations = {
        nixos-vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos-vmware
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = import ./home;
            }
          ];
        };
        surface-book = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.microsoft-surface-common
            ./hosts/surface-book
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.qdl = import ./home;
            }
          ];
        };
      };
    };
}
