{ ... }:
{
  imports = [
    ./options.nix
    ./gtk.nix
    ./vicinae.nix
    ./ironbar.nix
    ./swaync.nix
    ./wm
  ];
  xdg.configFile."NEUX" = {
    source = ../assets/neux;
    recursive = true;
  };
}
