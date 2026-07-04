{ ... }: {
  programs.ironbar = {
    enable = true;
    systemd = true;

    config = {
      ironvar_defaults = {
        show_weather = true;
        tray_open = true;
        tray_closed = false;
      };

      monitors = {
        "" = [

          # ── TOP BAR ────────────────────────────────────────────────────
          {
            position = "top";
            name = "top-bar";
            height = "0";
            margin = {
              top = 12;
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
                        type = "label";
                        label = "<span font-family='Fira Mono Nerd Font'> </span>";
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
                "icon-size" = "14";
              }

              {
                type = "clock";
                format = "%b. %d %H:%M";
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
                        src = "/home/blade0/.config/ironbar/nc-star.svg";
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
            height = 64;
            name = "bottom-bar";

            start = [
              {
                type = "custom";
                class = "weather";
                tooltip = "Weather";
                transition_type = "none";
                show_if = "#show_weather";
                bar = [
                  {
                    type = "button";
                    on_click = "!io.github.danirabbit.nimbus";
                    widgets = [
                      {
                        type = "box";
                        orientation = "vertical";
                        valign = "center";
                        halign = "start";
                        widgets = [
                          {
                            type = "label";
                            label = "{{poll:60000:/home/blade0/.config/NEUX/weather.sh temp}} ~ {{poll:9:/home/blade0/.config/NEUX/weather.sh condition}}";
                            class = "bold";
                          }
                          {
                            type = "label";
                            label = "{{poll:60000:/home/blade0/.config/NEUX/weather.sh location}}";
                            class = "subtitle";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }

              {
                type = "custom";
                class = "separator";
                transition_type = "none";
                show_if = "#show_weather";
                bar = [
                  {
                    type = "box";
                    widgets = [
                      {
                        type = "image";
                        src = "/home/blade0/.config/ironbar/separator.svg";
                      }
                    ];
                  }
                ];
              }
            ];

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
                        src = "/home/blade0/.config/ironbar/apps.png";
                        size = 38;
                      }
                    ];
                  }
                ];
              }

              {
                type = "launcher";
                icon_size = 38;
                favorites = [
                  "app.zen_browser.zen"
                  "org.gnome.Nautilus"
                  "org.gnome.Ptyxis"
                ];
              }

              {
                type = "custom";
                class = "separator";
                bar = [
                  {
                    type = "box";
                    widgets = [
                      {
                        type = "image";
                        src = "/home/blade0/.config/ironbar/separator.svg";
                      }
                    ];
                  }
                ];
              }

              {
                type = "launcher";
                class = "launcher-favs";
                icon_size = 38;
                favorites = [
                  "app.zen_browser.zen"
                  "org.gnome.Nautilus"
                  "org.gnome.Ptyxis"
                ];
              }

              {
                type = "custom";
                class = "separator";
                bar = [
                  {
                    type = "box";
                    widgets = [
                      {
                        type = "image";
                        src = "/home/blade0/.config/ironbar/separator.svg";
                      }
                    ];
                  }
                ];
              }

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
                        src = "/home/blade0/.config/ironbar/trash.png";
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
                class = "separator";
                bar = [
                  {
                    type = "box";
                    widgets = [
                      {
                        type = "image";
                        src = "/home/blade0/.config/ironbar/separator.svg";
                      }
                    ];
                  }
                ];
              }

              {
                type = "custom";
                class = "music";
                bar = [
                  {
                    type = "button";
                    valign = "center";
                    halign = "end";
                    on_click = "popup:toggle";
                    widgets = [
                      {
                        type = "box";
                        orientation = "vertical";
                        valign = "center";
                        halign = "end";
                        widgets = [
                          {
                            type = "label";
                            label = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh title}}";
                            justify = "right";
                            class = "bold";
                          }
                          {
                            type = "label";
                            label = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh artist}}";
                            justify = "right";
                            class = "subtitle";
                          }
                        ];
                      }
                      {
                        type = "image";
                        src = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh art}}";
                        size = 40;
                      }
                    ];
                  }
                ];
                popup = [
                  {
                    type = "box";
                    orientation = "vertical";
                    widgets = [
                      {
                        type = "image";
                        src = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh art}}";
                        size = 128;
                      }
                      {
                        type = "label";
                        label = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh title}}";
                        class = "title";
                      }
                      {
                        type = "label";
                        label = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh artist}}";
                        class = "subtitle";
                      }
                      {
                        type = "label";
                        label = "{{poll:500:/home/blade0/.config/NEUX/mpris.sh album}}";
                        class = "subtitle";
                      }
                      {
                        type = "box";
                        orientation = "horizontal";
                        halign = "center";
                        widgets = [
                          {
                            type = "button";
                            class = "music-btn";
                            label = "<span>󰒭</span>";
                            on_click = "!playerctl previous";
                          }
                          {
                            type = "button";
                            class = "music-btn";
                            label = "<span>󰐊</span>";
                            on_click = "!playerctl play-pause";
                          }
                          {
                            type = "button";
                            class = "music-btn";
                            label = "<span>󰒭</span>";
                            on_click = "!playerctl next";
                          }
                        ];
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
  };
}
