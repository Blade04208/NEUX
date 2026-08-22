{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.neux.wm == "hyprland") {
    wayland.windowManager.hyprland.extraConfig = ''
      function neuxSetupHyprbars()
        if type(hl.plugin) ~= "table" or hl.plugin.hyprbars == nil then
          return false
        end

        hl.config({
          plugin = {
            hyprbars = {
              bar_height             = 22,
              bar_color              = "rgb(181818)",
              bar_blur               = true,
              bar_part_of_window     = false,
              bar_padding            = 8,
              bar_button_padding     = 5,
              bar_buttons_alignment  = "right",
              bar_text_size          = 11,
              bar_text_font          = "Fira Sans",
              bar_text_align         = "left",
            },
          },
        })

        hl.plugin.hyprbars.add_button({
          bg_color = "rgb(cc3e3e)",
          fg_color = "rgb(ffffff)",
          size     = 10,
          icon     = "X",
          action   = "hyprctl dispatch 'hl.dsp.window.close()'",
        })

        hl.plugin.hyprbars.add_button({
          bg_color = "rgb(2f2f2f)",
          fg_color = "rgb(ffffff)",
          size     = 10,
          icon     = "_",
          action   = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })'",
        })

        return true
      end
      -- plugin configs need to be loaded after the plugin is loaded, but thats after the config is
      -- evaluated so we have to run the Gambler 5000 to load the config
      hl.on("hyprland.start", function()
        local attempts = 0
        local function trySetup()
          attempts = attempts + 1
          if neuxSetupHyprbars() then
            return
          end
          if attempts < 50 and type(hl.timer) == "function" then
            hl.timer(trySetup, { timeout = 100, type = "oneshot" })
          end
        end
        trySetup()
      end)
    '';
  };
}
