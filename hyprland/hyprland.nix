{
  wayland.windowManager.hyprland.settings = 
  let 
    player_priority = "--player=spotify,any%";
    audio_text = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@";
  in  {
    "$mod" = "SUPER";
    "$wallpaper" = "hyprctl hyprpaper wallpaper ',~/wallpaper.png'"
    monitor = [
      ",preferred,auto,1"
    ];
    bind = [
      "$mod, Return, exec, kitty"
      "$mod, D, exec, fuzzel"
      "$mod SHIFT, Q, killactive"

      "$mod, F, fullscreen, 0"
      "$mod SHIFT, F, fakefullscreen"

      "$mod, greater, movecurrentworkspacetomonitor, r"
      "$mod, less, movecurrentworkspacetomonitor, l"

      "$mod SHIFT, R, forcerendererreload"

      "$mod, SHIFT, space, togglefloating"

      "$mod, H, movefocus, left"
      "$mod, J, movefocus, down"
      "$mod, K, movefocus, up"
      "$mod, L, movefocus, right"

      "$mod SHIFT, H, movewindow, left"
      "$mod SHIFT, J, movewindow, down"
      "$mod SHIFT, K, movewindow, up"
      "$mod SHIFT, L, movewindow, right"

      ", XF86AudioPlay, exec, playerctl ${player_priority} play-pause"
      ", XF86AudioStop, exec, playerctl ${player_priority} stop"
      ", XF86AudioPrev, exec, playerctl ${player_priority} previous"
      ", XF86AudioNext, exec, playerctl ${player_priority} next"

      ", XF86Calculator, exec, qalculate-gtk"

      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"

      "$mod ALT, W, exec, $wallpaper"
    ] ++
    (builtins.concatLists (builtins.genList(
      x: let
        ws = toString(x+1);
      in [
        "$mod, ${ws}, workspace, ${ws}"
        "$mod SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
      ]
      ) 9) # workspace amount
    );
    bindel = [
      "Shift, XF86AudioRaiseVolume, exec, ${audio_text} 10%+"
      ", XF86AudioRaiseVolume, exec, ${audio_text} 5%+"
      "CTRL, XF86AudioRaiseVolume, exec, ${audio_text} 1%+"

      "Shift, XF86AudioLowerVolume, exec, ${audio_text} 10%-"
      ", XF86AudioLowerVolume, exec, ${audio_text} 5%-"
      "CTRL, XF86AudioLowerVolume, exec, ${audio_text} 1%-"
    ];
    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86MicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];
    winowrulev2 = [
      "move 0,0,title:^(flameshot)"
      "nofullscreenrequest,title:^(flameshot)"

      "workspace 4, class:(?i)^(Discord)"
      "workspace 8, class:(?i)^(Obsidian)"
    ];
    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY"

      "waybar"
      "dunst"
      "swaylock"
    ];
    env = [
      "WLR_DRM_DEVICES,/dev/dri/cardo:/dev/dri/card1"
    ];
    input = {
      kb_options = "caps:escape"
    };
    decoration = {
      blur.enabled = false;
      drop_shadow = false;
    };
    misc = {
      vfr = true;
      force_default_wallpaper = 0;
    };
    animations.enabled = false;
}
