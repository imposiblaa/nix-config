{ pkgs, ... }: {

  programs.kitty.enable = true;
  programs.wofi.enable = true;
  services.hyprpaper.enable = true;

  home.packages = [
    pkgs.libnotify
  ];

  wayland.windowManager.hyprland = {
    enable = true;


    settings = {
      monitor = [
        "eDP-1, 3456x2160@60, 2560x720, 2"
        "DP-8, 2560x1440@60, 0x0, 1"
      ];

      "exec-once" = [
        "waybar"
        "hyprpaper"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Returnsd, exec, kitty"
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
