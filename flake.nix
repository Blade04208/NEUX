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
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosModules.default = { pkgs, ... }: {
        imports = [
          ./system/default.nix
        ];
      };

      homeManagerModules.default = { pkgs, ... }: {
        imports = [
          inputs.vicinae.homeManagerModules.default
          inputs.ironbar.homeManagerModules.default
          ./home/default.nix
        ];

        _module.args.vicinaeExtensions =
          inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
      };
    };
}
