{ inputs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  imports = [
    ./gtk.nix
    ./vicinae.nix
  ];

}
