{
  config,
  lib,
  ...
}:
let
  hl = import ./lib.nix { inherit lib; };

  env =
    name: value:
    {
      _args = [
        name
        value
      ];
    };
in
{
  config = lib.mkIf (config.neux.wm == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      on = [
        {
          _args = [
            "hyprland.start"
            (hl.inline ''
              function()
                hl.exec_cmd(
                  "dbus-update-activation-environment --systemd --all" ..
                  " && systemctl --user import-environment" ..
                  " && systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland"
                )
                hl.exec_cmd("hyprpaper")
                hl.exec_cmd("wl-clip-persist --clipboard regular")
                hl.exec_cmd("swayosd-server")
                hl.exec_cmd("systemctl --user start hyprpolkitagent")
                hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
                hl.exec_cmd("ironbar")
                hl.exec_cmd("vicinae server")
                hl.exec_cmd("$HOME/.config/NEUX/checkin.sh")
                hl.exec_cmd("hyprctl setcursor Adwaita 24")
              end
            '')
          ];
        }
      ];

      env = lib.mkDefault [
        (env "XCURSOR_SIZE" "24")
        (env "HYPRCURSOR_SIZE" "24")
      ];
    };
  };
}
