{ ... }: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 5;
      control-center-margin-bottom = 5;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      control-center-width = 500;
      control-center-height = 600;
      fit-to-screen = true;
      layer = "top";
      cssPriority = "user";
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      notification-window-width = 350;
      notification-inline-replies = true;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "title"
        "buttons-grid"
        "backlight"
        "volume"
        "inhibitors"
        "notifications"
        "mpris"
      ];
      widget-config = {
        title = {
          text = "Action Center";
          clear-all-button = false;
        };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          autohide = true;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
        };
        backlight = {
          label = "󰃠";
          # device = "intel_backlight";
          subsystem = "backlight";
          min = 10;
        };
        buttons-grid = {
          actions = [
            {
              label = "  Wifi";
              command = "swaync-client -cp -sw; vicinae 'vicinae://launch/@dagimg-dot/store.vicinae.wifi-commander/'";
            }
            {
              label = "󰂯 Bluetooth";
              command = "swaync-client -cp -sw; vicinae 'vicinae://launch/@Gelei/store.vicinae.bluetooth/'";
            }
            {
              label = " Color Picker";
              command = "swaync-client -cp -sw; sleep 0.01; hyprpicker";
            }
            {
              label = "󰉔 Wallpaper";
              command = "swaync-client -cp -sw; vicinae 'vicinae://launch/scripts/wallpaper.sh'";
            }
            {
              label = "Do Not Disturb";
              type = "toggle";
              command = "swaync-client -d";
              update-command = "swaync-client -D";
            }
          ];
        };
      };
    };
    style = builtins.readFile ../assets/swaync.css;
  };
}
