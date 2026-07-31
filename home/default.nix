{ ... }:
{
  imports = [
    ./options.nix
    ./gtk.nix
    ./vicinae.nix
    ./ironbar.nix
    ./wm
  ];
  xdg.configFile."NEUX" = {
    source = ./assets/neux;
    recursive = true;
  };
}
