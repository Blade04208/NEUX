{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (builtins.elem "sway" config.neux.activeWMs) {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      hyprpaper
      hyprpicker
      hyprlock
    ];

    xdg.portal = {
      config.sway.default = [
        "gtk"
      ];
    };
  };
}
