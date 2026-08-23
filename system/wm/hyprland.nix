{
  config,
  pkgs,
  lib,
  hyprlandPackage,
  hyprlandPortalPackage,
  ...
}:
{
  config = lib.mkIf (builtins.elem "hyprland" config.neux.activeWMs) {
    programs.hyprland = {
      enable = true;
      package = hyprlandPackage;
      portalPackage = hyprlandPortalPackage;
      withUWSM = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      hyprpaper
      hyprpicker
      hyprlock
    ];

    xdg.portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };
}
