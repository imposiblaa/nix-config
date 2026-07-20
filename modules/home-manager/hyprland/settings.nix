{pkgs, inputs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      plugin = {
        split-monitor-workspaces = {
          count = 6;
          keep_focused = 0;
          enable_persistent_workspaces = 1;
        };
      };

      monitor = [
        "eDP-1, 3456x2160@60, 2560x720, 2"
        "DP-8, 2560x1440@60, 0x0, 1"
        ", preferred, auto, 1"
      ];

      input = {
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          scroll_factor = 0.8;
        };
        sensitivity = 0;
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 12;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.92;
        fullscreen_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          offset = "0 4";
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          new_optimizations = true;
          xray = false;
          ignore_opacity = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.5, 0, 1, 0.5"
          "smoothIn, 0.5, -0.51, 0.5, 1.5"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, smoothIn, slide"
          "border, 1, 10, default"
          "borderangle, 1, 100, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 6, overshot, slide"
          "specialWorkspace, 1, 6, overshot, slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
      };

      "exec-once" = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user restart hyprpaper.service"
        "ags run --gtk4 ~/.config/ags/app.ts"
        "hyprpaper"
        "mako"
        "hypridle"
        "nm-applet --indicator"
      ];

      "$mod" = "SUPER";

      bind = [
        # Applications
        "$mod, Return, exec, kitty"
        "$mod, R, exec, wofi --show drun"
        "$mod, E, exec, kitty -e yazi"
        "$mod, B, exec, brave"
        "$mod, Escape, exec, hyprlock"

        # Window management
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, F, fullscreen, 0"
        "$mod SHIFT, F, fullscreen, 1"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move windows
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Screenshots
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast copy screen"
        "$mod, Print, exec, grimblast save area ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"

        # Media
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # Special workspaces (scratchpad)
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"
      ];

      binde = [
        # Volume (with OSD)
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        # Brightness (with OSD)
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        # Resize
        "$mod ALT, H, resizeactive, -30 0"
        "$mod ALT, L, resizeactive, 30 0"
        "$mod ALT, K, resizeactive, 0 -30"
        "$mod ALT, J, resizeactive, 0 30"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrule = [
        # Float dialog / picker windows
        "float on, match:title ^(Open)$"
        "float on, match:title ^(Save)$"
        "float on, match:title ^(Open File)(.*)$"
        "float on, match:title ^(Save File)(.*)$"
        "float on, match:title ^(Choose)(.*)$"
        "float on, match:title ^(Confirm)(.*)$"
        # Float desktop portal dialogs
        "float on, match:class ^(xdg-desktop-portal-gtk)$"
        "float on, match:class ^(xdg-desktop-portal-hyprland)$"
        # Float utility apps
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(nm-connection-editor)$"
        "float on, match:class ^(blueman-manager)$"
        "float on, match:class ^(.blueman-manager-wrapped)$"
        "float on, match:class ^(org.gnome.Calculator)$"
        # Float picture-in-picture
        "float on, match:title ^(Picture-in-Picture)$"
        "pin on, match:title ^(Picture-in-Picture)$"
      ];
    };

    # Load plugin synchronously (not exec-once) so dispatchers are
    # available before the bind lines that reference them.
    extraConfig = let
      pluginPath = "${inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces}/lib/libsplit-monitor-workspaces.so";
    in ''
      plugin = ${pluginPath}

      bind = $mod, 1, split-workspace, 1
      bind = $mod, 2, split-workspace, 2
      bind = $mod, 3, split-workspace, 3
      bind = $mod, 4, split-workspace, 4
      bind = $mod, 5, split-workspace, 5
      bind = $mod, 6, split-workspace, 6
      bind = $mod SHIFT, 1, split-movetoworkspace, 1
      bind = $mod SHIFT, 2, split-movetoworkspace, 2
      bind = $mod SHIFT, 3, split-movetoworkspace, 3
      bind = $mod SHIFT, 4, split-movetoworkspace, 4
      bind = $mod SHIFT, 5, split-movetoworkspace, 5
      bind = $mod SHIFT, 6, split-movetoworkspace, 6
    '';
  };
}
