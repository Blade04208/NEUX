local terminal    = "ptyxis --new-window"
local fileManager = "nautilus -w"
local menu        = "vicinae toggle"


local mainMod = "SUPER" -- Sets "Windows" key as main modifier
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("kitty"))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("vicinae 'vicinae://launch/clipboard/history'"))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("vicinae vicinae://launch/files/search"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("vicinae vicinae://launch/system/browse-apps"))
hl.bind(mainMod .. " + BRACKETLEFT", hl.dsp.exec_cmd("ironbar bar top-bar toggle-visible"))
hl.bind(mainMod .. " + BRACKETRIGHT", hl.dsp.exec_cmd("ironbar bar bottom-bar toggle-visible"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"))
hl.bind("CONTROL + ALT + SPACE", hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("vicinae vicinae://launch/wm/switch-windows"))
hl.bind("SUPER + CONTROL + SHIFT + R", hl.dsp.exec_cmd("pkill ironbar; ironbar"))
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))


hl.bind("SUPER + ALT + F11",
    hl.dsp.exec_cmd(
        "bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send \"Test notification with body image\" \"This notification should contain your user account <b>image</b>. Oh and here is a random image in your Pictures folder: <img src=\\\"$RANDOM_IMAGE\\\" alt=\\\"Testing image\\\"/>\" -a \"Hyprland\" -p -h \"string:image-path:/var/lib/AccountsService/icons/$USER\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Open the random image\" -A \"action3=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"'")
)
hl.bind("SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send \"Test notification\" \"This notification should contain a random image in your <b>Pictures</b> folder.\n<i>Flick right to dismiss!</i>\" -a \"Discord (fake)\" -p -h \"string:image-path:$RANDOM_IMAGE\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"'")
)
hl.bind("SUPER + ALT + Equal",
    hl.dsp.exec_cmd("notify-send 'Urgent notification' 'Ah hell no' -u critical -a 'Hyprland keybind'"))

--------- layout switching -----------
hl.bind(mainMod .. "+ ALT + TAB", function()
    local current = hl.get_config("general.layout")

    hl.dispatch(hl.dsp.exec_cmd("swayosd-client --custom-icon 'info-outline-symbolic' --custom-message " .. current))
end)
hl.bind(mainMod .. " + TAB", function()
    local layouts = { "dwindle", "scrolling" }
    local current = hl.get_config("general.layout")

    local idx = 1
    for i, l in ipairs(layouts) do
        if l == current then
            idx = i
            break
        end -- why is lua so stupid man 😭
    end

    local next_layout = layouts[(idx % #layouts) + 1]
    hl.config({ general = { layout = next_layout } })
    hl.dispatch(hl.dsp.exec_cmd("swayosd-client --custom-icon 'view-dual-symbolic' --custom-message " .. next_layout))
end)
-----------------------------------------------
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind("Print",
    hl.dsp.exec_cmd(
        'ironbar var set show_weather false; grim - | satty --fullscreen -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"; ironbar var set show_weather true'))
hl.bind("SUPER + F1", function()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        return
    end

    hl.config({
        general = {
            gaps_in = 0,
            gaps_out = 0, -- Disable gaps
            border_size = 0,
        },

        animations = {
            enabled = false, -- Disable animations
        },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        }
    })
end)

local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind("SUPER + Minus", function() zoomfunction(-0.3) end)
hl.bind("SUPER + Equal", function() zoomfunction(0.3) end)

--# Zoom with keypad
hl.bind("SUPER + code:82", function() zoomfunction(-0.3) end)
hl.bind("SUPER + code:86", function() zoomfunction(0.3) end)

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))


-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true })

hl.bind("code:66", hl.dsp.exec_cmd("sleep 0.04; swayosd-client --caps-lock"), { locked = true, repeating = true })


-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("ALT + F4",
    function()
        hl.exec_cmd(
            "notify-send \"Wrong close keybind\" \"Super+Q to close. Use Alt+F4 for Windows VMs\" -a Hyprland")
    end,
    { non_consuming = true })
