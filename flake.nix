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
      vicinae,
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # note - "username" below is meant for fast hm rebuilds. DO NOT COMMIT CHANGES TO THIS USERNAME ok thank you
      username = "blade0";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/default.nix ];
        extraSpecialArgs = { inherit username; };
      };

      homeManagerModules.default = [
        vicinae.homeManagerModules.default
        ./home/default.nix
      ];

      # system-wide stuff
      nixosModules.default = ./system/default.nix;
    };
}
