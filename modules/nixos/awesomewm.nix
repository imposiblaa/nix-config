{ pkgs, ... }: {

  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
  }; 

  services.displayManager.ly.enable = true;

}
