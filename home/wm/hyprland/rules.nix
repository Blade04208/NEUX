{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.neux.wm == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
        {
          name = "move-hyprland-run";
          match.class = "hyprland-run";
          move = "20 monitor_h-120";
          float = true;
        }
        {
          name = "float-sushi";
          match.class = "org.gnome.NautilusPreviewer";
          float = true;
        }
        {
          name = "satty-fullscreen";
          match.class = "satty";
          fullscreen = true;
          no_anim = true;
          float = true;
        }
      ];

      layer_rule = [
        {
          match.namespace = "ironbar";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.3;
        }
        {
          match.namespace = "swayosd";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.3;
        }
        {
          match.namespace = "swaync-control-center";
          blur = true;
          ignore_alpha = 0;
          no_anim = true;
        }
        {
          match.namespace = "swaync-notification-window";
          blur = true;
          ignore_alpha = 0;
          no_anim = true;
        }
        {
          match.namespace = "vicinae";
          blur = true;
          ignore_alpha = 0.3;
        }
        {
          match.namespace = "swayosd";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.3;
          no_anim = true;
        }
      ];
    };
  };
}
