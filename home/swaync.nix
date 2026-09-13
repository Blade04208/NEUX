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
        "backlight"
        "volume"
        "inhibitors"
        "notifications"
        "mpris"
      ];
      widget-config = {
        title = {
          text = "Action Center";
          clear-all-button = true;
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
      };
    };
    style = builtins.readFile ../assets/swaync.css;
  };
}
