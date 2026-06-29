{
  pkgs,
  ...
}:
{

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "NEUX";
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
  xdg.configFile."gtk-4.0/gtk.css".source = ../assets/gtk/4.css;
  xdg.configFile."gtk-3.0/gtk.css".source = ../assets/gtk/3.css;

}
