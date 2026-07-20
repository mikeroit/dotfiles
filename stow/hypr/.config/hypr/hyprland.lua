local terminal = "kitty"
local file_manager = "thunar"
local launcher = "wofi --show drun"

-- Use the preferred mode for any connected monitor.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 8,
        border_size = 2,
        layout = "dwindle",

        col = {
            active_border = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)",
        },
    },

    decoration = {
        rounding = 6,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = false,
        },
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,

        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
        },
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("mako")
end)

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(file_manager))

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

h1.bind("SUPER + SHIFT + E", h1.dsp.exec_cmd("hyprshutdown"))

for workspace = 1, 10 do
    local key = workspace % 10

    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({ workspace = workspace })
    )

    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = workspace })
    )
end

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        "mkdir -p \"$HOME/Pictures/Screenshots\" && grim \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png\""
    )
)

hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        "mkdir -p \"$HOME/Pictures/Screenshots\" && grim -g \"$(slurp)\" \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png\""
    )
)
