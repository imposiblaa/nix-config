{ pkgs, ... }: {

  programs.rofi = {
    enable = true;
  };
  
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
    };
  };
 
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show drun";
      bars = [];
      
      gaps = {
        inner = 10;
        outer = 5;
      };
      
      keybindings = {
        "Mod4+Return" = "exec kitty";
        "Mod4+d" = "exec rofi -show drun";
        "Mod4+q" = "kill";
      };

      startup = [
        { command = "systemctl --user restart polybar"; notification = false; }
      ];
    };
  };

  services.picom = {
    enable = true;
    package = pkgs.picom-pijulius;
    backend = "glx";
    vSync = true;
   
    settings = {
      corner-radius = 12;
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      shadow = true;
      fading = true;
    };
  };
}
