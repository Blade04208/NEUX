hl.on("hyprland.start", function()
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
    hl.exec_cmd("$HOME/.config/neux/checkin.sh")
    hl.exec_cmd("hyprctl setcursor Adwaita 24")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
