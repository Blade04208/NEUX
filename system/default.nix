{ pkgs, ... }:
{
  imports = [
    ./bridge.nix
    ./wm
  ];

  environment.systemPackages = with pkgs; [
    # backup apps - kitty
    kitty
    # shell
    ironbar
    swaynotificationcenter
    playerctl
    vicinae
    brightnessctl
    swayosd
    # screenshots
    grim
    slurp
    satty
    # bugfixes - giaselbhbr
    wl-clip-persist
    # styling - fira
    fira-sans
    nerd-fonts.fira-mono
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
    ];
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };

  systemd.services.swayosd-libinput-backend.enable = true;
}
