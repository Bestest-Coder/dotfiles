hl.on("hyprland.start", function ()
    hl.exec_cmd("dunst")
    hl.exec_cmd("swaylock")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("easyeffects --gapplication-service")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.config({
        animations = {enabled = false},
        decoration = {blur = {enabled = false}},
        input = {
            kb_options = "caps:escape",
            touchpad = { disable_while_typing = true},
        },
        cursor = { no_hardware_cursors = 1}
})

for i = 1,9 do
    hl.bind(string.format("SUPER + %d",i), hl.dsp.focus({ workspace = i, on_current_monitor = false}))
    hl.bind(string.format("SUPER + SHIFT + %d",i), hl.dsp.window.move({ workspace = i, false}))
end

local directions = {["H"] = "l", ["J"] = "d", ["K"] = "u", ["L"] = "r"}
for key,dir in pairs(directions) do
    hl.bind("SUPER + ".. key, hl.dsp.focus({window = dir}))
    hl.bind("SUPER + SHIFT +" .. key, hl.dsp.window.move({direction = dir}))
end

hl.bind("SUPER + Return", hl.dsp.exec_cmd("wezterm"))
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close("activewindow"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bestestscreenshot"))

hl.bind("SUPER + F", hl.dsp.window.fullscreen({"fullscreen", "toggle", "activewindow"}))

hl.bind("SUPER + comma", hl.dsp.workspace.move({monitor = "l"}))
hl.bind("SUPER + period", hl.dsp.workspace.move({monitor = "r"}))
hl.bind("SUPER + CTRL + comma", hl.dsp.workspace.move({monitor = "d"}))
hl.bind("SUPER + CTRL + period", hl.dsp.workspace.move({monitor = "u"}))

hl.bind("SUPER + SHIFT + Space", hl.dsp.window.float({"toggle", "activewindow"}))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),{ locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"),{ locked = true, repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),{ locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),{ locked = true, repeating = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-gtk"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"),{ locked = true, repeating = true })

hl.bind("XF86Tools", hl.dsp.exec_cmd("bestestoolscript"))

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), {locked = true })

--hl.bind("SUPER + mouse:272", 
--hl.bind("SUPER + SHIFT + mouse:272",

hl.monitor({
        output = "eDP-2",
        mode = "preferred",
        position = "0x0",
        scale = 1,
        vrr = 2
})

hl.monitor({
        output = "desc:Dell Inc. DELL U2312HM T9MJ318A191L",
        mode = "preferred",
        position = "auto-up",
        scale = 1
})

hl.monitor({
        output = "desc:Dell Inc. DELL U2312HM T9MJ318ABCTL",
        mode = "preferred",
        position = "auto",
        scale = 1,
        transform = 1
})
