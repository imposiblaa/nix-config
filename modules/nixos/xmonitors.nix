{pkgs, ...}: {
  services.xserver.xrandrHeads = [
    {
      output = "eDP-1";
      primary = true;
      monitorConfig = ''
        Mode 2456x2160
        Option "RightOf" "DP-2-3-3"
        Option "Scale" "0.5x0.5"
      '';
    }
    {
      output = "DP-2-3-3";
      monitorConfig = ''
        Mode 2560x1440
      '';
    }
  ];
}
