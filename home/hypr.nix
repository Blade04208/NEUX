{ pkgs, ... }:

let
  WallpaperDefault = pkgs.writeText "hyprpaper.conf" ''
    wallpaper {
        monitor =
        path = $HOME/Pictures/Wallpapers/peace.jpg
        fit_mode = cover
    }

  '';
in
{
  xdg.configFile."hypr/hyprland.lua".source = ../assets/hypr/hyprland.lua;
  xdg.configFile."hypr/binds.lua".source = ../assets/hypr/binds.lua;
  xdg.configFile."hypr/decor.lua".source = ../assets/hypr/decor.lua;
  xdg.configFile."hypr/execs.lua".source = ../assets/hypr/execs.lua;
  xdg.configFile."hypr/rules.lua".source = ../assets/hypr/rules.lua;
  xdg.configFile."hypr/hyprlock.conf".source = ../assets/hypr/hyprlock.conf;
  systemd.user.tmpfiles.rules = [
    "f %h/.config/hypr/hyprpaper.conf 0644 - - - ${WallpaperDefault}"
    "f %h/.config/hypr/custom.lua 0755 - - - -"
  ];
}
