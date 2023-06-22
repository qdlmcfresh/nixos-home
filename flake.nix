{
  description = "QDL's NixOS-Configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
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
    };
  };
}
