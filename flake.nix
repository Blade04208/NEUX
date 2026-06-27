{
  description = "AURES NEUX Hyprland dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    nimbus.url = "github:Blade04208/nimbus";
  };
  outputs =
  inputs@{
    vicinae,
    self,
    nixpkgs,
    home-manager,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "blade0";
  in
  {

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home/default.nix ];
      extraSpecialArgs = { inherit username inputs; };
    };

    homeManagerModules.default = [
      vicinae.homeManagerModules.default
      ./home/default.nix
    ];

    nixosModules.default = ./system/default.nix;
  };
}
