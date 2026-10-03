{
  lib,
  pkgs,
  neuxTheming,
  ...
}:
let
  darkTheme = { gtk-application-prefer-dark-theme = 1; };
in
{

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "NEUX";
      package = neuxTheming.neux-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };

    font = {
      name = "Fira Sans";
      package = pkgs.fira-sans;
    };

    gtk3.extraConfig = darkTheme;
    gtk4.extraConfig = darkTheme;
  };

  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "NEUX";
      font-name = "Fira Sans 11";
      document-font-name = "Fira Sans 11";
      monospace-font-name = "FiraMono Nerd Font 11";
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".source =
    "${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-4.0/gtk.css";
  xdg.configFile."gtk-3.0/gtk.css".source =
    "${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-3.0/gtk.css";

  home.activation.ohMyGodFlatpaksWhyAreYouSoGoddamnStubbornJustUseTheDamnFiles =
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      for cfg in "$HOME"/.var/app/*/config; do
        [ -d "$cfg" ] || continue
        mkdir -p "$cfg/gtk-4.0" "$cfg/gtk-3.0"
        ln -sfn ${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-4.0/gtk.css "$cfg/gtk-4.0/gtk.css"
        ln -sfn ${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-3.0/gtk.css "$cfg/gtk-3.0/gtk.css"
        [ -e "$cfg/gtk-4.0/settings.ini" ] || cp ~/.config/gtk-4.0/settings.ini "$cfg/gtk-4.0/settings.ini"
      done
    '';
}
