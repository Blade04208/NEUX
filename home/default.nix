{ ... }:
{
  imports = [
    ./gtk.nix
    ./vicinae.nix
    ./ironbar.nix
    ./hypr.nix
  ];
  xdg.configFile."NEUX" = {
    source = ../assets/neux;
    recursive = true;
  };
}
