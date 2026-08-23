{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.neux.wm == "sway") {
    wayland.windowManager.sway.config.window.commands = [
      {
        # ghost xwayland drag windows
        command = "floating enable";
        criteria = {
          class = "^$";
          instance = "^$";
          title = "^$";
        };
      }
      {
        command = "floating enable, move position center";
        criteria.app_id = "hyprland-run";
      }
      {
        command = "floating enable";
        criteria.app_id = "org.gnome.NautilusPreviewer";
      }
      {
        command = "floating enable";
        criteria.class = "org.gnome.NautilusPreviewer";
      }
      {
        command = "fullscreen enable";
        criteria.app_id = "satty";
      }
    ];

    wayland.windowManager.sway.extraConfig = ''
      no_focus [class="^$" instance="^$" title="^$"]

      layer_effects "ironbar" "blur enable; blur_ignore_transparent enable; shadows disable"
      layer_effects "swayosd" "blur enable; blur_ignore_transparent enable; shadows disable"
      layer_effects "swaync-control-center" "blur enable; blur_ignore_transparent enable; shadows disable"
      layer_effects "swaync-notification-window" "blur enable; blur_ignore_transparent enable; shadows disable"
      layer_effects "vicinae" "blur enable; blur_ignore_transparent enable; shadows disable"
    '';
  };
}
