{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = ../../wallpaper1.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    imageScalingMode = "fill";
    opacity = {
      applications = 0.9;
      terminal = 0.8;
      popups = 0.9;
    };
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;

  }; 
}
