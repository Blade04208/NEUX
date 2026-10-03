{ config, ... }:
let
  cfg = config.neux;
  cfgDir = "${config.xdg.configHome}/ironbar";
  ncDir = "${config.xdg.configHome}/NEUX";
  sep = {
    type = "custom";
    class = "separator";
    transition_type = "none";
    bar = [
      {
        type = "box";
        widgets = [
          {
            type = "image";
            src = "${cfgDir}/separator.svg";
          }
        ];
      }
    ];
  };
in
{
  config = {
    programs.ironbar = {
      enable = true;
      systemd = true;

      config = {
        ironvar_defaults = {
          show_weather = true;
          tray_open = false;
          tray_closed = true;
          mpris_active = false;
        };

        monitors = {
          "" = [

            # ── TOP BAR ────────────────────────────────────────────────────
            {
              position = "top";
              name = "top-bar";
              height = "0";
              margin = {
                top = 14;
                bottom = 0;
                left = 14;
                right = 14;
              };
              popup_gap = 7;

              start = [
                {
                  type = "custom";
                  class = "vicinae";
                  tooltip = "Search with the Launcher";
                  bar = [
                    {
                      name = "vicinae-btn";
                      type = "button";
                      on_click = "!vicinae toggle";
                      widgets = [
                        {
                          type = "image";
                          src = "icon:system-search-symbolic";
                        }
                      ];
                    }
                  ];
                }

                {
                  type = "workspaces";
                }
              ];

              center = [
                {
                  type = "focused";
                  show_icon = true;
                  show_title = true;
                  truncate = {
                    max_length = 80;
                    mode = "end";
                  };
                }
              ];

              end = [
                {
                  type = "tray";
                  show_if = "#tray_open";
                }

                {
                  type = "custom";
                  class = "tray-button-container";
                  tooltip = "Open/Close the System Tray";
                  bar = [
                    {
                      name = "tray-btn";
                      type = "button";
                      on_click = "!sh -c 'if [ '$(ironbar var get tray_open)' = 'true' ]; then ironbar var set tray_open false; ironbar var set tray_closed true; else ironbar var set tray_open true; ironbar var set tray_closed false; fi'";
                      widgets = [
                        {
                          type = "image";
                          src = "icon:go-previous-symbolic";
                          size = 16;
                          show_if = "#tray_closed";
                          transition_type = "none";
                        }
                        {
                          type = "image";
                          src = "icon:go-next-symbolic";
                          size = 16;
                          show_if = "#tray_open";
                          transition_type = "none";
                        }
                      ];
                    }
                  ];
                }

                {
                  type = "network_manager";
                  "icon-size" = "14";
                  on_click = "!XDG_CURRENT_DESKTOP=gnome gnome-control-center wifi";
                  types_blacklist = [ "loopback" ];
                }

                {
                  type = "battery";
                  format = ''🯧<span background="white" color="black"> {percentage} </span> '';
                  show_icon = false;
                  profiles.charging.when = {
                    charging = true;
                  };
                  profiles.charging.format = ''🯧<span background="white" color="black"> {percentage} </span>  󰚥'';
                }

                {
                  type = "clock";
                  # WHY THE FUCK DO SPANS ONLY ACCEPT "" AS A VALID STRING
                  # FUCK YOU PANGO
                  format = ''<span alpha="52428">%A, %b. %d</span>  <b>%H:%M</b>'';
                }

                {
                  type = "custom";
                  class = "notif-center";
                  tooltip = "Notification Center";
                  bar = [
                    {
                      name = "notif-btn";
                      type = "button";
                      on_click = "!swaync-client -t";
                      widgets = [
                        {
                          type = "image";
                          src = "${cfgDir}/nc-star.svg";
                        }
                      ];
                    }
                  ];
                }
              ];
            }

            # ── BOTTOM BAR ─────────────────────────────────────────────────
            {
              position = "bottom";
              height = 63;
              name = "bottom-bar";

              start = [ ];

              center = [
                {
                  type = "custom";
                  class = "apps";
                  tooltip = "All Applications";
                  bar = [
                    {
                      name = "apps-btn";
                      type = "button";
                      on_click = "!vicinae 'vicinae://launch/system/browse-apps'";
                      widgets = [
                        {
                          type = "image";
                          src = "${cfgDir}/apps.png";
                          size = 38;
                        }
                      ];
                    }
                  ];
                }

                {
                  type = "launcher";
                  icon_size = 42;
                  favorites = cfg.favorites;
                }

                sep

                {
                  type = "launcher";
                  class = "launcher-favs";
                  icon_size = 42;
                  favorites = cfg.favorites;
                }

                sep

                {
                  type = "custom";
                  class = "trash";
                  tooltip = "Trash";
                  bar = [
                    {
                      name = "trash-btn";
                      type = "button";
                      on_click = "!nautilus trash://";
                      widgets = [
                        {
                          type = "image";
                          src = "${cfgDir}/trash.png";
                          size = 38;
                        }
                      ];
                    }
                  ];
                }
              ];

              end = [
                {
                  type = "custom";
                  class = "music";
                  show_if = "#mpris_active";
                  bar = [
                    {
                      type = "button";
                      valign = "center";
                      halign = "end";
                      on_click = "!swaync-client -t";
                      widgets = [
                        {
                          type = "box";
                          orientation = "vertical";
                          valign = "center";
                          halign = "end";
                          widgets = [
                            {
                              type = "label";
                              label = "{{watch:${ncDir}/mpris.sh title}}";
                              justify = "right";
                              class = "bold";
                            }
                            {
                              type = "label";
                              label = "{{watch:${ncDir}/mpris.sh artist}}";
                              justify = "right";
                              class = "subtitle";
                            }
                          ];
                        }
                        {
                          type = "image";
                          class = "bar-art";
                          src = "{{watch:${ncDir}/mpris.sh art}}";
                          size = 38;
                        }
                      ];
                    }
                  ];
                }
              ];
            }

          ];
        };
      };
      style = builtins.readFile ../assets/ironbar.css;
    };
    xdg.configFile."ironbar" = {
      source = ../assets/ironbar;
      recursive = true;
    };
  };
}
