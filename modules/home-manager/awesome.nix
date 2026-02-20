{ pkgs, ... }: {

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

  home.file.".config/awesome" = {
    source = pkgs.fetchFromGithub {
      owner = "lcpz";
      repo = "awesome-copycats";
      rev = "master";
    };
    recursive = true;
  };
  
  home.packages = with pkgs; [
    lua53Packages.lain
    lua53Packages.luafilesystem
  ];

  programs.rofi = {
    enable = true;
  };
}
