{ pkgs, inputs, ... }: {

  programs.kitty.enable = true;
  programs.wofi.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    libnotify
    # Screenshots
    grim
    slurp
    grimblast
    # Notifications
    mako
    # Lock / idle
    hyprlock
    hypridle
    # Media / audio
    playerctl
    pavucontrol
    wireplumber
    # Brightness
    brightnessctl
    # Clipboard
    wl-clipboard
    # Network
    networkmanagerapplet
    # System monitor
    btop
    # File manager
    yazi
    # OSD for volume/brightness
    swayosd
  ];

  # Notification daemon
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 8;
      border-size = 2;
      padding = "12,16";
      margin = "8";
      max-icon-size = 48;
      sort = "-time";
      layer = "overlay";
      anchor = "top-right";
    };
  };

  # Idle daemon
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Lock screen — fully managed by stylix
  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

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

      # gestures handled via touchpad input settings above

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
        "hyprctl plugin load ${inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces}/lib/libsplit-monitor-workspaces.so"
        # AGS v2 bar (replaces waybar)
        "ags run --gtk4 ~/.config/ags/app.ts"
        # waybar kept as fallback — remove once AGS is confirmed stable
        # "waybar"
        "hyprpaper"
        "mako"
        "hypridle"
        "swayosd-server"
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

        # Workspaces
        "$mod, 1, split-workspace, 1"
        "$mod, 2, split-workspace, 2"
        "$mod, 3, split-workspace, 3"
        "$mod, 4, split-workspace, 4"
        "$mod, 5, split-workspace, 5"
        "$mod, 6, split-workspace, 6"

        "$mod SHIFT, 1, split-movetoworkspace, 1"
        "$mod SHIFT, 2, split-movetoworkspace, 2"
        "$mod SHIFT, 3, split-movetoworkspace, 3"
        "$mod SHIFT, 4, split-movetoworkspace, 4"
        "$mod SHIFT, 5, split-movetoworkspace, 5"
        "$mod SHIFT, 6, split-movetoworkspace, 6"

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
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "mpris"
        ];
        modules-right = [
          "custom/weather"
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "bluetooth"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          all-outputs = false;
          format-icons = {
            default = "●";
            active = "◉";
            empty = "○";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "1";
            "8" = "2";
            "9" = "3";
            "10" = "4";
            "11" = "5";
            "12" = "6";
          };
          persistent-workspaces = { "*" = 6; };
        };

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = true;
        };

        "mpris" = {
          format = "{player_icon} {title} — {artist}";
          format-paused = "{status_icon} {title} — {artist}";
          player-icons = {
            default = "▶";
            mpv = "🎵";
            spotify = "";
            firefox = "󰈹";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 60;
          ignored-players = [ "firefox" ];
        };

        "custom/weather" = {
          exec = "curl -s 'wttr.in/?format=%c+%t+%h' 2>/dev/null || echo '? --'";
          interval = 1800;
          tooltip = true;
          tooltip-format = "{}";
        };

        "cpu" = {
          interval = 5;
          format = " {usage}%";
          tooltip = true;
          on-click = "kitty -e btop";
        };

        "memory" = {
          interval = 5;
          format = " {used:0.1f}G";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
          on-click = "kitty -e btop";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "󰂯 {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
            headphone = "󰋋";
            headset = "󰋎";
          };
          scroll-step = 5;
          on-click = "pavucontrol";
          tooltip-format = "{desc} — {volume}%";
        };

        "network" = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰤭 offline";
          format-linked = "󰈀 {ifname} (no IP)";
          tooltip-format = "{essid} ({ifname}) {ipaddr}/{cidr}\n↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}";
          on-click = "nm-connection-editor";
          interval = 5;
        };

        "bluetooth" = {
          format = "󰂯 {status}";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
          format-disabled = "󰂲";
          format-off = "󰂲";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ "󰋙" "󰃝" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        "battery" = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo} — {power:.1f}W";
        };

        "clock" = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%a %b %d}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          on-click = ""; # toggle alt format on click
          interval = 60;
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#fabd2f'><b>{}</b></span>";
              days = "<span color='#ebdbb2'>{}</span>";
              weeks = "<span color='#83a598'><b>W{}</b></span>";
              weekdays = "<span color='#d3869b'><b>{}</b></span>";
              today = "<span color='#fb4934'><b><u>{}</u></b></span>";
            };
          };
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = ''
      /* Extra tweaks on top of stylix — pill-shaped modules, spacing */
      * {
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        border-radius: 10px;
      }

      .modules-right > widget:last-child > #tray {
        margin-right: 4px;
      }

      #workspaces button {
        border-radius: 6px;
        padding: 0 6px;
        margin: 2px 2px;
        min-width: 24px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        font-weight: bold;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #bluetooth,
      #backlight,
      #tray,
      #mpris,
      #custom-weather {
        border-radius: 8px;
        padding: 2px 10px;
        margin: 3px 2px;
      }

      #battery.warning {
        color: #fabd2f;
      }

      #battery.critical {
        color: #fb4934;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to { opacity: 0.5; }
      }
    '';
  };

  stylix.targets = {
    waybar.enable = true;
    hyprland.enable = true;
    wofi.enable = true;
    kitty.enable = true;
    mako.enable = true;
    hyprlock.enable = true;
  };
}
