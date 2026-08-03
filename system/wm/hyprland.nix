{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (builtins.elem "hyprland" config.neux.activeWMs) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      hyprpaper
      hyprpicker
      hyprlock
    ];

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
