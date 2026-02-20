{ pkgs, config, ...}: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
    };
    script = "polybar top &";
    settings = {
      # This is the "Magic" block
      "settings" = {
        screenchange-reload = true;
      };
  
      "bar/top" = {
        width = "100%";
        height = "24pt";
        
        # Use the Stylix-injected color variables
        # Note: Stylix defines these in a [colors] section it creates automatically
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base05}";
  
        line-size = "3pt";
        
        border-size = "4pt";
        border-color = "#00000000"; # Transparent border for a 'floating' look
  
        radius = 10;
        padding-left = 0;
        padding-right = 1;
  
        module-margin = 1;
  
        separator = "|";
        separator-foreground = "\${colors.disabled}";
  
        # Fonts: Stylix usually handles the default font, 
        # but you can explicitly call the mono font here
        font-0 = "JetBrainsMono Nerd Font:size=10;2";
  
        modules-left = "xworkspaces xwindow";
        modules-right = "pulseaudio memory cpu date";
  
        cursor-click = "pointer";
        enable-ipc = true;
        
        # Moves it to the top
        bottom = false;
      };
  
      # Basic Module Example using Stylix Colors
      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline= "\${colors.primary}";
        label-active-padding = 1;
      };
      
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%H:%M";
        label = "%date%";
        label-foreground = "\${colors.primary}";
      };
    };
  };
}
