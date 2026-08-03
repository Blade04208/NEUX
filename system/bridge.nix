{ config, lib, ... }:
{
  options.neux.activeWMs = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [ "hyprland" ]);
    default =
      if config ? home-manager.users then
        lib.unique (
          lib.filter (x: x != null) (
            lib.mapAttrsToList (_: userCfg: userCfg.neux.wm or null) config.home-manager.users
          )
        )
      else
        [ ];
    description = "This option allows users to define which window manager they want ona  user-level and this adds it at a system package. This option generally shouldnt be changed unless you know what you're doing.";
  };
}
