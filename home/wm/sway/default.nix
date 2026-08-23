{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./binds.nix
    ./decor.nix
    ./execs.nix
    ./rules.nix
  ];

  config = lib.mkIf (config.neux.wm == "sway") {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      systemd.enable = true;
      checkConfig = false;

      config = {
        modifier = "Mod4";
        keybindings = { };
        bars = [ ];
        modes = { };
        terminal = "ptyxis --new-window";

        window.titlebar = false;

        gaps = {
          inner = 5;
          outer = 10;
          smartGaps = false;
          smartBorders = "off";
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "gb";
          };
          "type:touchpad" = {
            natural_scroll = "enabled";
          };
        };

        focus = {
          followMouse = true;
          newWindow = "focus";
        };
      };

      extraConfig = ''
        default_border none
        default_floating_border none
        floating_modifier Mod4 normal

        output * adaptive_sync on
      '';
    };

    home.sessionVariables = {
      XCURSOR_SIZE = "24";
    };
  };
}
