{pkgs, pkgs-unstable, inputs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    configType = "lua";

    plugins = [
      pkgs-unstable.hyprlandPlugins.hyprsplit
    ];

    settings = {
      # All config goes through hl.config({}) — individual hl.general(), hl.decoration() etc. don't exist
      config = {
        input = {
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap_to_click = true;
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
        animations = {enabled = true;};
        dwindle = {
          preserve_split = true;
          force_split = 2;
        };
        master = {new_status = "master";};
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          enable_swallow = true;
          swallow_regex = "^(kitty)$";
        };
      };

      monitor = [
        {output = "eDP-1"; mode = "3456x2160@60"; position = "2560x720"; scale = 2;}
        {output = "DP-8"; mode = "2560x1440@144.00Hz"; position = "0x0"; scale = 1;}
        {output = "DP-10"; mode = "1920x1080@143.99Hz"; position = "-1920x400"; scale = 1;}
        {output = ""; mode = "preferred"; position = "auto"; scale = 1;}
      ];

      window_rule = [
        {match.title = "^(Open)$"; float = true;}
        {match.title = "^(Save)$"; float = true;}
        {match.title = "^(Open File)(.*)$"; float = true;}
        {match.title = "^(Save File)(.*)$"; float = true;}
        {match.title = "^(Choose)(.*)$"; float = true;}
        {match.title = "^(Confirm)(.*)$"; float = true;}
        {match.class = "^(xdg-desktop-portal-gtk)$"; float = true;}
        {match.class = "^(xdg-desktop-portal-hyprland)$"; float = true;}
        {match.class = "^(pavucontrol)$"; float = true;}
        {match.class = "^(nm-connection-editor)$"; float = true;}
        {match.class = "^(blueman-manager)$"; float = true;}
        {match.class = "^(.blueman-manager-wrapped)$"; float = true;}
        {match.class = "^(org.gnome.Calculator)$"; float = true;}
        {match.title = "^(Picture-in-Picture)$"; float = true; pin = true;}
      ];
    };

    extraConfig = let
      initLua = builtins.readFile "${inputs.hyprsplit}/init.lua";
    in ''
      -- Bezier curves
      hl.curve("overshot",  { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05} } })
      hl.curve("smoothOut", { type = "bezier", points = { {0.5, 0},     {1, 0.5}    } })
      hl.curve("smoothIn",  { type = "bezier", points = { {0.5, -0.51}, {0.5, 1.5}  } })
      hl.curve("linear",    { type = "bezier", points = { {0.0, 0.0},   {1.0, 1.0}  } })

      -- Animations
      hl.animation({ leaf = "windows",          enabled = true, speed = 5,   bezier = "overshot",  style = "slide" })
      hl.animation({ leaf = "windowsOut",       enabled = true, speed = 4,   bezier = "smoothOut", style = "slide" })
      hl.animation({ leaf = "windowsMove",      enabled = true, speed = 4,   bezier = "smoothIn",  style = "slide" })
      hl.animation({ leaf = "border",           enabled = true, speed = 10,  bezier = "default" })
      hl.animation({ leaf = "borderangle",      enabled = true, speed = 100, bezier = "linear",    style = "loop" })
      hl.animation({ leaf = "fade",             enabled = true, speed = 10,  bezier = "default" })
      hl.animation({ leaf = "workspaces",       enabled = true, speed = 6,   bezier = "overshot",  style = "slide" })
      hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6,   bezier = "overshot",  style = "slidevert" })

      -- Autostart
      hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user restart hyprpaper.service")
        hl.exec_cmd("ags run --gtk4 ~/.config/ags/app.ts")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("mako")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("nm-applet --indicator")
      end)

      local mod = "SUPER"

      -- Applications
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
      hl.bind(mod .. " + R",      hl.dsp.exec_cmd("wofi --show drun"))
      hl.bind(mod .. " + E",      hl.dsp.exec_cmd("kitty -e yazi"))
      hl.bind(mod .. " + B",      hl.dsp.exec_cmd("brave"))
      hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))

      -- Window management
      hl.bind(mod .. " + C",         hl.dsp.window.close())
      hl.bind(mod .. " + M",         hl.dsp.exit())
      hl.bind(mod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P",         hl.dsp.window.pseudo())
      hl.bind(mod .. " + F",         hl.dsp.window.fullscreen())
      hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

      -- Focus
      hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))
      hl.bind(mod .. " + H",     hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + L",     hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + K",     hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + J",     hl.dsp.focus({ direction = "down" }))

      -- Move windows
      hl.bind(mod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
      hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

      -- Screenshots
      hl.bind("Print",           hl.dsp.exec_cmd("grimblast copy area"))
      hl.bind("SHIFT + Print",   hl.dsp.exec_cmd("grimblast copy screen"))
      hl.bind(mod .. " + Print", hl.dsp.exec_cmd("grimblast save area ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"))

      -- Media keys
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),        { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

      -- Volume and brightness (repeating)
      hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { repeating = true, locked = true })
      hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { repeating = true, locked = true })
      hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          { repeating = true, locked = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          { repeating = true, locked = true })

      -- Resize (repeating)
      hl.bind(mod .. " + ALT + H", hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + L", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + K", hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
      hl.bind(mod .. " + ALT + J", hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })

      -- Mouse binds
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Special workspace (scratchpad)
      hl.bind(mod .. " + grave",         hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))

      -- hyprsplit (inlined via IIFE since require() has no module path configured)
      local hyprsplit = (function()
        ${initLua}
      end)()
      hyprsplit.config({ num_workspaces = 6, persistent_workspaces = true })

      for i = 1, 6 do
        hl.bind(mod .. " + " .. i, hyprsplit.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hyprsplit.dsp.window.move({ workspace = i, follow = false }))
      end
    '';
  };
}
