--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule

hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, workspace = "e+0", float = true, center = true })
hl.window_rule({ match = { class = "GTK Application" }, workspace = "e+0", float = true, center = true })

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
hl.window_rule({
    name = "nimbus",
    match = { class = "io.github.danirabbit.nimbus" },
    float = true,
    move = "10 monitor_h-300",
    persistent_size = true,
    size = "1000, 300"
})
hl.layer_rule({
    match = { namespace = "ironbar" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.3,
})

-- Blur swaync notification center
hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0,
    no_anim = true
})

-- Blur swaync notification popups
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0,
    no_anim = true
})

hl.layer_rule({
    match = { namespace = "vicinae" },
    blur = true,
    ignore_alpha = 0.3,
})

hl.window_rule({
    name = "satty-fullscreen",
    match = {
        class = "satty"
    },
    fullscreen = true,
    no_anim = true,
    float = true
})
