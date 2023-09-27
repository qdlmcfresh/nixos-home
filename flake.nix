{
  description = "QDL's NixOS-Configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    leonm1-hardware.url = "github:leonm1/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    bw-key.url = "github:qdlmcfresh/bw-key";
    bw-key.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, nixos-hardware, leonm1-hardware, home-manager, nix-vscode-extensions, bw-key, disko, ... }:
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
        fuji-server = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              disko.nixosModules.disko
              ./hosts/fuji-server
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs;
                home-manager.users.qdl = import ./home/headless;
              }
            ];
          };
      };
    };
}
