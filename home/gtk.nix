{
  pkgs,
  neuxTheming,
  ...
}:
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

    gtk3.extraConfig = {
      # gtk-theme-name = "adw-gtk3-dark";
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
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
  # libadwaita apps ignore gtk-theme-name and only read these user overrides,
  # so layer the NEUX css on top of the default theme instead of using it as one
  xdg.configFile."gtk-4.0/gtk.css".source =
    "${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-4.0/gtk.css";
  xdg.configFile."gtk-3.0/gtk.css".source =
    "${neuxTheming.neux-gtk-theme}/share/themes/NEUX/gtk-3.0/gtk.css";
}
