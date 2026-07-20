{pkgs, ...}: {
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

  programs.hyprlock.enable = true;

  systemd.user.services.swayosd-server = {
    Unit = {
      Description = "SwayOSD Server";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "on-failure";
      RestartSec = "3";
      # Hyprland defaults to wayland-1; must be explicit since systemd user
      # services don't inherit WAYLAND_DISPLAY from the compositor environment.
      Environment = "WAYLAND_DISPLAY=wayland-1";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
