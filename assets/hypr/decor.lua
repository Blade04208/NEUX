-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 10,

        border_size      = 0,

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing    = false,

        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.8,
        dim_inactive     = true,
        dim_strength     = 0.2,

        shadow           = {
            enabled      = true,
            range        = 10,
            render_power = 1,
            color        = 0x58000000,
            offset       = { 0, 2 }
        },

        blur             = {
            enabled           = true,
            size              = 15,
            passes            = 3,
            vibrancy          = 1,
            new_optimizations = true,
            popups            = true,
            input_methods     = true,
            xray              = true
        },
    },

    animations = {
        enabled = true,
    },
    misc = {
        vrr                      = 1,
        disable_splash_rendering = true,
        focus_on_activate        = true,
        force_default_wallpaper  = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo    = true, -- If true disables the random hyprland logo / anime girl background. :(
    }
})

-- curves and anims by end-4, absolutely goated
-- Curves
hl.curve("expressiveFastSpatial", {
    type = "bezier",
    points = { { 0.42, 1.67 }, { 0.21, 0.90 } }
})
hl.curve("expressiveSlowSpatial", {
    type = "bezier",
    points = { { 0.39, 1.29 }, { 0.35, 0.98 } }
})
hl.curve("expressiveDefaultSpatial", {
    type = "bezier",
    points = { { 0.38, 1.21 }, { 0.22, 1.00 } }
})
hl.curve("emphasizedDecel", {
    type = "bezier",
    points = { { 0.05, 0.7 }, { 0.1, 1 } }
})
hl.curve("emphasizedAccel", {
    type = "bezier",
    points = { { 0.3, 0 }, { 0.8, 0.15 } }
})
hl.curve("standardDecel", {
    type = "bezier",
    points = { { 0, 0 }, { 0, 1 } }
})
hl.curve("menu_decel", {
    type = "bezier",
    points = { { 0.1, 1 }, { 0, 1 } }
})
hl.curve("menu_accel", {
    type = "bezier",
    points = { { 0.52, 0.03 }, { 0.72, 0.08 } }
})
hl.curve("stall", {
    type = "bezier",
    points = { { 1, -0.1 }, { 0.7, 0.85 } }
})
-- Configs
-- windows
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "popin 80%"
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel",
    style = "popin 90%"
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel"
})
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "slide"
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "emphasizedDecel"
})

-- layers
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 2.7,
    bezier = "emphasizedDecel",
    style = "popin 93%"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 2.4,
    bezier = "menu_accel",
    style = "popin 94%"
})
-- fade
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 0.5,
    bezier = "menu_decel"
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 2.7,
    bezier = "stall"
})
-- workspaces
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide"
})
-- specialWorkspace
hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 2.8,
    bezier = "emphasizedDecel",
    style = "slidevert"
})
hl.animation({
    leaf = "specialWorkspaceOut",
    enabled = true,
    speed = 1.2,
    bezier = "emphasizedAccel",
    style = "slidevert"
})
-- zoom
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 3,
    bezier = "standardDecel"
})
