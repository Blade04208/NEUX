{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.neux.wm == "sway") {
    wayland.windowManager.sway.config.startup = [
      {
        command = "dbus-update-activation-environment --systemd --all && systemctl --user restart xdg-desktop-portal";
      }
      { command = "swaybg -m fill -i $HOME/Pictures/Wallpapers/peace.jpg"; }
      { command = "wl-clip-persist --clipboard regular"; }
      { command = "swayosd-server"; }
      { command = "systemctl --user start hyprpolkitagent"; }
      { command = ''"gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"''; }
      { command = "ironbar"; }
      { command = "vicinae server"; }
      { command = "$HOME/.config/NEUX/checkin.sh"; }
    ];
  };
}
