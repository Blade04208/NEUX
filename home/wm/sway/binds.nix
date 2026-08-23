{
  config,
  lib,
  ...
}:
let
  mainMod = "Mod4";

  key = k: "${mainMod}+${k}";

  bind = k: cmd: "bindsym ${k} ${cmd}";

  bindWith =
    flags: k: cmd:
    "bindsym ${lib.concatStringsSep " " flags} ${k} ${cmd}";

  bindCode =
    flags: code: cmd:
    "bindcode ${lib.concatStringsSep " " flags} ${code} ${cmd}";

  workspaces = builtins.genList (
    i:
    let
      n = i + 1;
      digit = toString (lib.mod n 10);
    in
    [
      (bind "${mainMod}+${digit}" "workspace number ${toString n}")
      (bind "${mainMod}+Shift+${digit}" "move container to workspace number ${toString n}")
    ]
  ) 10;

  binds =
    [
      (bind (key "t") "exec ptyxis --new-window")
      (bind "${mainMod}+Shift+t" "exec kitty")
      (bind (key "q") "kill")
      (bind (key "m") "exec swaynag -t warning -m 'Exit NEUX session?' -B 'Yes, exit' 'swaymsg exit'")
      (bind (key "e") "exec nautilus -w")
      (bind "${mainMod}+Shift+c" "exec hyprpicker -a -n")
      (bind (key "v") "exec vicinae 'vicinae://launch/clipboard/history'")
      (bind (key "Alt+space") "floating toggle")
      (bindWith [ "--release" ] "Super_L" "exec vicinae toggle")
      (bind (key "s") "exec vicinae 'vicinae://launch/files/search'")
      (bind (key "a") "exec vicinae 'vicinae://launch/system/browse-apps'")
      (bind (key "bracketleft") "exec ironbar bar top-bar toggle-visible")
      (bind (key "bracketright") "exec ironbar bar bottom-bar toggle-visible")
      (bind (key "l") "exec hyprlock")
      (bind (key "period") "exec vicinae 'vicinae://launch/core/search-emojis'")
      (bind "Control+Alt+space" "exec vicinae 'vicinae://launch/core/search-emojis'")
      (bind "Alt+Tab" "exec vicinae 'vicinae://launch/wm/switch-windows'")
      (bind "${mainMod}+Control+Shift+r" "exec bash -c \"pkill ironbar && ironbar\"")
      (bind "${mainMod}+Alt+equal" ''exec notify-send 'Urgent notification' 'Ah hell no' -u critical -a "NEUX keybind"'')
      (bind "${mainMod}+Alt+Tab" "exec swayosd-client --custom-icon info-outline-symbolic --custom-message tiling")
      (bind (key "Tab") "layout toggle split, exec swayosd-client --custom-icon view-dual-symbolic --custom-message tiling")
      (bind (key "j") "layout toggle split")
      (bind "Print" ''
        exec ironbar var set show_weather false && grim - | satty --fullscreen -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png" && ironbar var set show_weather true'')
      (bind "${mainMod}+F1" "exec $HOME/.config/NEUX/perf-mode.sh")
      (bind (key "f") "fullscreen toggle")
      (bind (key "left") "focus left")
      (bind (key "right") "focus right")
      (bind (key "up") "focus up")
      (bind (key "down") "focus down")
      (bind "${mainMod}+Shift+s" "scratchpad show")
      (bind "${mainMod}+Alt+Shift+s" "move container to scratchpad")
      (bindWith [ "--whole-window" ] "${mainMod}+button4" "workspace prev_on_output")
      (bindWith [ "--whole-window" ] "${mainMod}+button5" "workspace next_on_output")
      (bindWith [ "--locked" ] "XF86AudioRaiseVolume" "exec swayosd-client --output-volume raise")
      (bindWith [ "--locked" ] "XF86AudioLowerVolume" "exec swayosd-client --output-volume lower")
      (bindWith [ "--locked" ] "XF86AudioMute" "exec swayosd-client --output-volume mute-toggle")
      (bindWith [ "--locked" ] "XF86AudioMicMute" "exec swayosd-client --input-volume mute-toggle")
      (bindWith [ "--locked" ] "XF86MonBrightnessUp" "exec swayosd-client --brightness raise")
      (bindWith [ "--locked" ] "XF86MonBrightnessDown" "exec swayosd-client --brightness lower")
      (bindCode [ "--locked" ] "66" "exec sleep 0.04 && swayosd-client --caps-lock")
      (bindWith [ "--locked" ] "XF86AudioNext" "exec playerctl next")
      (bindWith [ "--locked" ] "XF86AudioPause" "exec playerctl play-pause")
      (bindWith [ "--locked" ] "XF86AudioPlay" "exec playerctl play-pause")
      (bindWith [ "--locked" ] "XF86AudioPrev" "exec playerctl previous")
      (bind "Alt+F4" ''exec notify-send "Wrong close keybind" "Super+Q to close. Use Alt+F4 for Windows VMs" -a NEUX'')
    ]
    ++ lib.flatten workspaces;
in
{
  config = lib.mkIf (config.neux.wm == "sway") {
    wayland.windowManager.sway.extraConfig = lib.concatStringsSep "\n" binds;
  };
}
