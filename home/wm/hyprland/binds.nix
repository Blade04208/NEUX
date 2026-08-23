{
  config,
  lib,
  ...
}:
let
  hl = import ./lib.nix { inherit lib; };

  terminal = "ptyxis --new-window";
  fileManager = "nautilus -w";
  menu = "vicinae toggle";
  mainMod = "SUPER";
  key = k: "${mainMod} + ${k}";

  execFn =
    cmd:
    hl.inline ''
      function()
        hl.exec_cmd(${hl.toLua cmd})
      end
    '';

  zoomBind =
    k: delta:
    hl.bind (key k) (
      hl.inline ''
        function()
          hl.config({
            cursor = { zoom_factor = math.min(3.0, math.max(1.0, hl.get_config("cursor:zoom_factor") + ${delta})) },
          })
        end
      ''
    );
  workspaces = builtins.genList (
    i:
    let
      n = i + 1;
      digit = toString (lib.mod n 10);
    in
    [
      (hl.bind "${mainMod} + ${digit}" (hl.focusWorkspace n))
      (hl.bind "${mainMod} + SHIFT + ${digit}" (hl.moveToWorkspace n))
    ]
  ) 10;
in
{
  config = lib.mkIf (config.neux.wm == "hyprland") {
    wayland.windowManager.hyprland.settings.bind =
      [
        (hl.bind (key "T") (hl.exec terminal))
        (hl.bind "${mainMod} + SHIFT + T" (hl.exec "kitty"))
        (hl.bind (key "Q") (hl.inline "hl.dsp.window.close()"))
        (hl.bind (key "M") (
          hl.exec "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
        ))
        (hl.bind (key "E") (hl.exec fileManager))
        (hl.bind "${mainMod} + SHIFT + C" (hl.exec "hyprpicker -a -n"))
        (hl.bind (key "V") (hl.exec "vicinae 'vicinae://launch/clipboard/history'"))
        (hl.bind (key "ALT + SPACE") (hl.inline ''hl.dsp.window.float({ action = "toggle" })''))
        (hl.bindWith { release = true; } (key "SUPER_L") (hl.exec menu))
        (hl.bind (key "S") (hl.exec "vicinae 'vicinae://launch/files/search'"))
        (hl.bind (key "A") (hl.exec "vicinae 'vicinae://launch/system/browse-apps'"))
        (hl.bind (key "BRACKETLEFT") (hl.exec "ironbar bar top-bar toggle-visible"))
        (hl.bind (key "BRACKETRIGHT") (hl.exec "ironbar bar bottom-bar toggle-visible"))
        (hl.bind (key "L") (hl.exec "hyprlock"))
        (hl.bind (key "PERIOD") (hl.exec "vicinae 'vicinae://launch/core/search-emojis'"))
        (hl.bind "CONTROL + ALT + SPACE" (hl.exec "vicinae 'vicinae://launch/core/search-emojis'"))
        (hl.bind "ALT + TAB" (hl.exec "vicinae 'vicinae://launch/wm/switch-windows'"))
        (hl.bind "SUPER + CONTROL + SHIFT + R" (hl.exec "pkill ironbar; ironbar"))
        (hl.bind "SUPER + SHIFT + ALT + Q" (hl.exec "hyprctl kill"))
        (hl.bind "SUPER + ALT + F11" (
          hl.exec ''
            bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send "Test notification with body image" "This notification should contain your user account <b>image</b>. Oh and here is a random image in your Pictures folder: <img src=\"$RANDOM_IMAGE\" alt=\"Testing image\"/>" -a "Hyprland" -p -h "string:image-path:/var/lib/AccountsService/icons/$USER" -t 6000 -i "discord" -A "openImage=Profile image" -A "action2=Open the random image" -A "action3=Useless button"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open "$RANDOM_IMAGE"'
          ''
        ))
        (hl.bind "SUPER + ALT + F12" (
          hl.exec ''
            bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send "Test notification" "This notification should contain a random image in your <b>Pictures</b> folder.
<i>Flick right to dismiss!</i>" -a "Discord (fake)" -p -h "string:image-path:$RANDOM_IMAGE" -t 6000 -i "discord" -A "openImage=Profile image" -A "action2=Useless button"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"'
          ''
        ))
        (hl.bind "SUPER + ALT + Equal" (
          hl.exec "notify-send 'Urgent notification' 'Ah hell no' -u critical -a 'Hyprland keybind'"
        ))
        (hl.bind "${mainMod} + ALT + TAB" (
          hl.inline ''
            function()
              hl.dispatch(hl.dsp.exec_cmd("swayosd-client --custom-icon 'info-outline-symbolic' --custom-message " .. hl.get_config("general.layout")))
            end
          ''
        ))
        (hl.bind "${mainMod} + TAB" (
          hl.inline ''
            function()
              local next_layout = (hl.get_config("general.layout") == "dwindle") and "scrolling" or "dwindle"
              hl.config({ general = { layout = next_layout } })
              hl.dispatch(hl.dsp.exec_cmd("swayosd-client --custom-icon 'view-dual-symbolic' --custom-message " .. next_layout))
            end
          ''
        ))
        (hl.bind (key "J") (hl.inline ''hl.dsp.layout("togglesplit")''))
        (hl.bind "Print" (
          hl.exec ''
            ironbar var set show_weather false; grim - | satty --fullscreen -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"; ironbar var set show_weather true
          ''
        ))
        (hl.bind "SUPER + F1" (
          hl.inline ''
            function()
              if hl.get_config("animations.enabled") then
                hl.config({
                  general = {
                    gaps_in = 0,
                    gaps_out = 0,
                    border_size = 0,
                  },
                  animations = { enabled = false },
                  decoration = {
                    shadow = { enabled = false },
                    blur = { enabled = false },
                    rounding = 0,
                  },
                })
              else
                hl.exec_cmd("hyprctl reload")
              end
            end
          ''
        ))
        (zoomBind "Minus" "-0.3")
        (zoomBind "Equal" "0.3")
        (zoomBind "code:82" "-0.3")
        (zoomBind "code:86" "0.3")
        (hl.bind (key "F") (hl.inline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })''))
        (hl.bind (key "ALT + F") (
          hl.inline ''hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" })''
        ))
        (hl.bind (key "left") (hl.focusDirection "left"))
        (hl.bind (key "right") (hl.focusDirection "right"))
        (hl.bind (key "up") (hl.focusDirection "up"))
        (hl.bind (key "down") (hl.focusDirection "down"))
        (hl.bind "${mainMod} + SHIFT + S" (hl.inline ''hl.dsp.workspace.toggle_special("magic")''))
        (hl.bind "${mainMod} + ALT + SHIFT + S" (hl.moveToWorkspace "special:magic"))
        (hl.bind (key "mouse_down") (hl.focusWorkspace "+1"))
        (hl.bind (key "mouse_up") (hl.focusWorkspace "-1"))
        (hl.bindWith { mouse = true; } (key "mouse:272") (hl.inline "hl.dsp.window.drag()"))
        (hl.bindWith { mouse = true; } (key "mouse:273") (hl.inline "hl.dsp.window.resize()"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86AudioRaiseVolume" (hl.exec "swayosd-client --output-volume raise"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86AudioLowerVolume" (hl.exec "swayosd-client --output-volume lower"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86AudioMute" (hl.exec "swayosd-client --output-volume mute-toggle"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86AudioMicMute" (hl.exec "swayosd-client --input-volume mute-toggle"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86MonBrightnessUp" (hl.exec "swayosd-client --brightness raise"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "XF86MonBrightnessDown" (hl.exec "swayosd-client --brightness lower"))
        (hl.bindWith {
          locked = true;
          repeating = true;
        } "code:66" (hl.exec "sleep 0.04; swayosd-client --caps-lock"))
        (hl.bindWith { locked = true; } "XF86AudioNext" (hl.exec "playerctl next"))
        (hl.bindWith { locked = true; } "XF86AudioPause" (hl.exec "playerctl play-pause"))
        (hl.bindWith { locked = true; } "XF86AudioPlay" (hl.exec "playerctl play-pause"))
        (hl.bindWith { locked = true; } "XF86AudioPrev" (hl.exec "playerctl previous"))
        (hl.bindWith { non_consuming = true; } "ALT + F4" (
          execFn ''notify-send "Wrong close keybind" "Super+Q to close. Use Alt+F4 for Windows VMs" -a Hyprland''
        ))
      ]
      ++ lib.flatten workspaces;
  };
}
