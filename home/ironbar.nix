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
              height = 68;
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
                              label = "{{poll:60000:${ncDir}/weather.sh temp}} ~ {{poll:9:${ncDir}/weather.sh condition}}";
                              class = "bold";
                            }
                            {
                              type = "label";
                              label = "{{poll:60000:${ncDir}/weather.sh location}}";
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
                  bar = sep.bar;
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
                sep
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
                          size = 56;
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
                          class = "album-art";
                          src = "{{watch:${ncDir}/mpris.sh art}}";
                          size = 160;
                        }
                        {
                          type = "label";
                          label = "{{watch:${ncDir}/mpris.sh title}}";
                          class = "title";
                          justify = "center";
                        }
                        {
                          type = "label";
                          label = "{{watch:${ncDir}/mpris.sh artist}}";
                          class = "subtitle";
                          justify = "center";
                        }
                        {
                          type = "label";
                          label = "{{watch:${ncDir}/mpris.sh album}}";
                          class = "subtitle";
                          justify = "center";
                        }
                        {
                          type = "box";
                          class = "music-progress-row";
                          halign = "center";
                          widgets = [
                            {
                              type = "label";
                              class = "time time-elapsed";
                              justify = "right";
                              label = "{{poll:1000:${ncDir}/mpris.sh position}}";
                            }
                            {
                              type = "progress";
                              name = "music-progress";
                              value = {
                                cmd = "${ncDir}/mpris.sh progress";
                                interval = 1000;
                              };
                              length = 200;
                            }
                            {
                              type = "label";
                              class = "time";
                              justify = "left";
                              label = "{{poll:1000:${ncDir}/mpris.sh length}}";
                            }
                          ];
                        }
                        {
                          type = "box";
                          class = "music-controls";
                          halign = "center";
                          widgets = [
                            {
                              type = "button";
                              name = "music-prev-btn";
                              class = "music-btn";
                              tooltip = "Previous";
                              on_click = "!playerctl previous";
                              widgets = [
                                {
                                  type = "image";
                                  src = "${cfgDir}/icons/prev.svg";
                                  size = 22;
                                }
                              ];
                            }
                            {
                              type = "button";
                              name = "music-playpause-btn";
                              class = "music-btn music-playpause";
                              tooltip = "Play/Pause";
                              on_click = "!playerctl play-pause";
                              widgets = [
                                {
                                  type = "image";
                                  src = "{{poll:1000:${ncDir}/mpris.sh state-icon}}";
                                  size = 26;
                                }
                              ];
                            }
                            {
                              type = "button";
                              name = "music-next-btn";
                              class = "music-btn";
                              tooltip = "Next";
                              on_click = "!playerctl next";
                              widgets = [
                                {
                                  type = "image";
                                  src = "${cfgDir}/icons/next.svg";
                                  size = 22;
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
