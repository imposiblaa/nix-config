{...}: {
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
          persistent-workspaces = {"*" = 6;};
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
          ignored-players = ["firefox"];
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
            default = ["󰕿" "󰖀" "󰕾"];
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
          format-icons = ["󰋙" "󰃝" "󰃟" "󰃠"];
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
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo} — {power:.1f}W";
        };

        "clock" = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%a %b %d}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          on-click = "";
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
}
