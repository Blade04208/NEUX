{
  config,
  pkgs,
  lib,
  hyprlandPackage,
  ...
}:

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
  imports = [
    ./binds.nix
    ./decor.nix
    ./execs.nix
    ./rules.nix
  ];

  config = lib.mkIf (cfg.wm == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPackage;
      configType = "lua";

      settings = {
        monitor = lib.mkDefault [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "1";
          }
        ];

        config = lib.mkDefault {
          dwindle = {
            preserve_split = true;
            smart_split = true;
          };

          master = {
            new_status = "master";
          };

          scrolling = {
            fullscreen_on_one_column = true;
          };

          input = {
            kb_layout = "gb";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
            };
          };
        };

        gesture = lib.mkDefault [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ];
      };
    };

    xdg.configFile."hypr/hyprlock.conf".source = ../../../assets/hypr/hyprlock.conf;

    systemd.user.tmpfiles.rules = [
      "f %h/.config/hypr/hyprpaper.conf 0644 - - - ${WallpaperDefault}"
    ];
  };
}
