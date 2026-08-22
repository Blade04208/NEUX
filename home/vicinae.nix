{
  vicinaeExtensions,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    extensions = with vicinaeExtensions; [
      nix
      wifi-commander
      power-profile
    ];
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
  xdg.dataFile."vicinae/scripts/NEUX" = {
    source = ../assets/vicinae/scripts/NEUX;
    recursive = true;
  };
  xdg.dataFile."vicinae/themes/neux.toml".source = ../assets/vicinae/themes/neux.toml;
  xdg.dataFile."vicinae/themes/icons/neux.png".source = ../assets/vicinae/themes/icons/neux.png;
}
