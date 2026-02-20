{ pkgs, ... }: {

  services.xserver = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
    };
  }; 

  services.displayManager.ly.enable = true;

}
