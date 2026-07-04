{
  ...
}:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = false;
      autoStart = false;
      # environment = {
      #   USE_LAYER_SHELL = 1;
      # };
    };

    settings = {
      close_on_focus_loss = false;
      pop_to_root_on_close = true;
      search_files_in_root = true;

      font = {
        rendering = "native";
        normal = {
          family = "Fira Sans";
        };
      };

      theme = {
        dark = {
          name = "neux";
        };
      };

      launcher_window = {
        opacity = 0.7;
        client_side_decorations = {
          enabled = true;
        };
      };

      keybinds = {
        "action.copy" = "control+C";
        "action.copy-name" = "control+shift+C";
        "action.copy-path" = "control+alt+V";
        "action.pin" = "control+P";
        "open-search-filter" = "control+F";
        "toggle-action-panel" = "alt+SPACE";
      };

      favorites = [ ];
      fallbacks = [
        "@knoopx/nix-0:packages"
        "files:search"
      ];

      providers = {
        "@Gelei/bluetooth-0" = {
          entrypoints = {
            devices = {
              alias = "bluetooth";
            };
          };
        };

        applications = {
          preferences = {
            defaultAction = "focus";
            launchPrefix = "";
            paths = [
              "$HOME/.local/share/applications"
              "$HOME/.local/share/flatpak/exports/share/applications"
              "/var/lib/flatpak/exports/share/applications"
              "$HOME/.nix-profile/share/applications"
              "/nix/profile/share/applications"
              "$HOME/.local/state/nix/profile/share/applications"
              "/etc/profiles/per-user/blade0/share/applications"
              "/nix/var/nix/profiles/default/share/applications"
              "/run/current-system/sw/share/applications"
            ];
          };
        };

        "browser-extension" = {
          enabled = false;
        };

        calculator = {
          entrypoints = {
            "refresh-rates" = {
              enabled = false;
            };
          };
        };

        core = {
          entrypoints = {
            about = {
              enabled = false;
            };
            documentation = {
              enabled = false;
            };
            "keybind-settings" = {
              enabled = false;
            };
            "manage-fallback" = {
              enabled = false;
            };
            "oauth-token-store" = {
              enabled = false;
            };
            "open-config-file" = {
              enabled = false;
            };
            "open-default-config" = {
              enabled = false;
            };
            "refresh-apps" = {
              enabled = false;
            };
            "reload-scripts" = {
              enabled = false;
            };
            "report-bug" = {
              enabled = false;
            };
            "search-builtin-icons" = {
              enabled = false;
            };
            settings = {
              enabled = false;
            };
            sponsor = {
              enabled = false;
            };
          };
        };

        developer = {
          enabled = false;
          entrypoints = {
            create = {
              enabled = false;
            };
          };
        };

        files = {
          preferences = {
            autoIndexing = true;
            excludedPaths = "/home/blade0/.cache";
            paths = "/home/blade0";
            watcherPaths = "";
          };
          entrypoints = {
            "rebuild-index" = {
              enabled = true;
            };
          };
        };

        font = {
          entrypoints = {
            browse = {
              enabled = true;
            };
          };
        };

        power = {
          entrypoints = {
            lock = {
              preferences = {
                confirm = false;
                customProgram = "hyprlock";
              };
            };
            logout = {
              preferences = {
                confirm = true;
                customProgram = "";
              };
            };
            "power-off" = {
              preferences = {
                confirm = true;
                customProgram = "";
              };
            };
            reboot = {
              preferences = {
                confirm = true;
                customProgram = "";
              };
            };
          };
        };

        snippets = {
          enabled = false;
        };

        system = {
          entrypoints = {
            "browse-apps" = {
              enabled = false;
            };
            run = {
              preferences = {
                "default-action" = "run";
              };
            };
            "toggle-mute" = {
              enabled = false;
            };
            "volume-0" = {
              enabled = false;
            };
            "volume-100" = {
              enabled = false;
            };
            "volume-25" = {
              enabled = false;
            };
            "volume-50" = {
              enabled = false;
            };
            "volume-75" = {
              enabled = false;
            };
            "volume-down" = {
              enabled = false;
            };
            "volume-up" = {
              enabled = false;
            };
          };
        };

        theme = {
          enabled = false;
          entrypoints = {
            set = {
              enabled = false;
            };
          };
        };

      }; # providers
    }; # settings
  };
}
