{
  config,
  lib,
  ...
}:
let
  hl = import ./lib.nix { inherit lib; };

  curve =
    name: p1: p2:
    {
      _args = [
        name
        {
          type = "bezier";
          points = [ p1 p2 ];
        }
      ];
    };

  animation = leaf: speed: bezier: style: { enabled = true; inherit leaf speed bezier; } // (lib.optionalAttrs (style != null) { inherit style; });
in
{
  config = lib.mkIf (config.neux.wm == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      curve = [
        (curve "expressiveFastSpatial" [ 0.42 1.67 ] [ 0.21 0.9 ])
        (curve "expressiveSlowSpatial" [ 0.39 1.29 ] [ 0.35 0.98 ])
        (curve "expressiveDefaultSpatial" [ 0.38 1.21 ] [ 0.22 1.0 ])
        (curve "emphasizedDecel" [ 0.05 0.7 ] [ 0.1 1.0 ])
        (curve "emphasizedAccel" [ 0.3 0.0 ] [ 0.8 0.15 ])
        (curve "standardDecel" [ 0.0 0.0 ] [ 0.0 1.0 ])
        (curve "menu_decel" [ 0.1 1.0 ] [ 0.0 1.0 ])
        (curve "menu_accel" [ 0.52 0.03 ] [ 0.72 0.08 ])
        (curve "stall" [ 1.0 (-0.1) ] [ 0.7 0.85 ])
      ];

      animation = [
        (animation "windowsIn" 3 "emphasizedDecel" "popin 80%")
        (animation "fadeIn" 3 "emphasizedDecel" null)
        (animation "windowsOut" 2 "emphasizedDecel" "popin 90%")
        (animation "fadeOut" 2 "emphasizedDecel" null)
        (animation "windowsMove" 3 "emphasizedDecel" "slide")
        (animation "border" 10 "emphasizedDecel" null)
        (animation "layersIn" 2.7 "emphasizedDecel" "popin 93%")
        (animation "layersOut" 2.4 "menu_accel" "popin 94%")
        (animation "fadeLayersIn" 0.5 "menu_decel" null)
        (animation "fadeLayersOut" 2.7 "stall" null)
        (animation "workspaces" 7 "menu_decel" "slide")
        (animation "specialWorkspaceIn" 2.8 "emphasizedDecel" "slidevert")
        (animation "specialWorkspaceOut" 1.2 "emphasizedAccel" "slidevert")
        (animation "zoomFactor" 3 "standardDecel" null)
      ];

      config = lib.mkDefault {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 0;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 0.8;
          dim_inactive = true;
          dim_strength = 0.2;

          shadow = {
            enabled = true;
            range = 10;
            render_power = 1;
            color = hl.inline "0x58000000";
            offset = [
              0
              2
            ];
          };

          blur = {
            enabled = true;
            size = 15;
            passes = 3;
            vibrancy = 1;
            new_optimizations = true;
            popups = true;
            input_methods = true;
            xray = true;
          };
        };

        animations = {
          enabled = true;
        };

        misc = {
          vrr = 1;
          disable_splash_rendering = true;
          focus_on_activate = true;
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };
      };
    };
  };
}
