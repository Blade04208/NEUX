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
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      hyprpaper
      hyprpicker
      hyprlock
      swaybg
    ];

    xdg.portal = {
      wlr.enable = true;
      config.sway.default = lib.mkForce [
        "wlr"
        "gtk"
      ];
    };
  };
}
