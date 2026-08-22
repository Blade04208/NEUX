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
    # band-aid fix - pin hyprland to a specific commit so allow hyprbars to build
    hyprland.url = "github:hyprwm/Hyprland/5751911091d2bbcd580597d489a1ec0b9dd542bd";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
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
      hyprlua = import ./home/wm/hyprland/lib.nix { lib = nixpkgs.lib; };
      caches = import ./caches.nix;
    in
    {

      nixConfig = {
        extra-substituters = caches.substituters;
        extra-trusted-public-keys = caches.trustedPublicKeys;
      };

      lib.hyprlua = hyprlua;

      nixosModules.default = { pkgs, ... }: {
        imports = [
          ./system/default.nix
        ];
      };

      homeManagerModules.default = { lib, pkgs, ... }: {
        imports = [
          inputs.vicinae.homeManagerModules.default
          inputs.ironbar.homeManagerModules.default
          ./home/default.nix
        ];

        _module.args.hyprlua = import ./home/wm/hyprland/lib.nix { inherit lib; };

        _module.args.hyprlandPlugins =
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system};

        _module.args.vicinaeExtensions =
          inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
      };

    };
}
