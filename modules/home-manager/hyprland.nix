{ pkgs, inputs, ... }: {

  programs.kitty.enable = true;
  programs.wofi.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;

  home.packages = [
    pkgs.libnotify
  ];

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
      input.touchpad.natural_scroll = true;

      "exec-once" = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user restart hyprpaper.service"
        "hyprctl plugin load ${inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces}/lib/libsplit-monitor-workspaces.so"
        "waybar"
        "hyprpaper"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, R, exec, wofi --show drun"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod&SHIFT, H, movewindow, l"
        "$mod&SHIFT, L, movewindow, r"
        "$mod&SHIFT, K, movewindow, u"
        "$mod&SHIFT, J, movewindow, d"

        "$mod, 1, split-workspace, 1"
        "$mod, 2, split-workspace, 2"
        "$mod, 3, split-workspace, 3"
        "$mod, 4, split-workspace, 4"
        "$mod, 5, split-workspace, 5"
        "$mod, 6, split-workspace, 6"

        "$mod&SHIFT, 1, split-movetoworkspace, 1"
        "$mod&SHIFT, 2, split-movetoworkspace, 2"
        "$mod&SHIFT, 3, split-movetoworkspace, 3"
        "$mod&SHIFT, 4, split-movetoworkspace, 4"
        "$mod&SHIFT, 5, split-movetoworkspace, 5"
        "$mod&SHIFT, 6, split-movetoworkspace, 6"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland.window" ];
        modules-right = [ "clock" "tray" ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          all-outputs = false;
          format-icons = {
            default = "";
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

        "clock" = {
          format = "{:%H:%M | %a %d}";
        };
      };

    };
  };

  stylix.targets = {
    waybar.enable = true;
    hyprland.enable = true;
    wofi.enable = true;
    kitty.enable = true;
  };
}
