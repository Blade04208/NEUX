{ lib, ... }:
{
  options.neux = {
    wm = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [
        "hyprland"
        "sway"
      ]);
      default = null;
      description = ''
        Which window manager NEUX should configure for this user. If not available already, this will be installed system-wide.
      '';
    };

    favorites = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Apps to pin to the Base Bar, e.g. "org.gnome.Nautilus".
      '';
    };
  };
}
