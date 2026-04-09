{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  services.displayManager.ly.enable = true;
}
