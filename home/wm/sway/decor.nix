{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.neux.wm == "sway") {
    wayland.windowManager.sway.extraConfig = ''
      corner_radius 10
      smart_corner_radius disable

      shadows enable
      shadow_color #00000058
      shadow_inactive_color #00000058
      shadow_blur_radius 10
      shadow_offset 0 2

      blur enable
      blur_radius 8
      blur_passes 3
      blur_xray enable

      default_dim_inactive 0.2
    '';
  };
}
