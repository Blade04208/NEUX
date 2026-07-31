{ config, pkgs, lib, ... }:

let
  cfg = config.neux;
  WallpaperDefault = pkgs.writeText "hyprpaper.conf" ''
    wallpaper {
        monitor =
        path = $HOME/Pictures/Wallpapers/peace.jpg
        fit_mode = cover
    }

  '';
in
{
  config = lib.mkIf (cfg.wm == "hyprland") {
    xdg.configFile =
      lib.genAttrs
        [
          "hypr/hyprland.lua"
          "hypr/binds.lua"
          "hypr/decor.lua"
          "hypr/execs.lua"
          "hypr/rules.lua"
          "hypr/hyprlock.conf"
        ]
        (name: {
          force = true;
          source = ../../assets + "/${name}";
        });

    systemd.user.tmpfiles.rules = [
      "f %h/.config/hypr/hyprpaper.conf 0644 - - - ${WallpaperDefault}"
      "f %h/.config/hypr/custom.lua 0755 - - - -"
    ];
  };
}
