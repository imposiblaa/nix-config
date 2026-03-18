{ pkgs, inputs, ... }:

let
  # Override ags to include astal libraries needed by our bar
  agsWithLibs = pkgs.ags.override {
    extraPackages = with pkgs.astal; [
      hyprland
      mpris
      battery
      network
      wireplumber
      tray
    ];
  };
in
{
  # Install ags with astal libraries baked in
  home.packages = [ agsWithLibs ];

  # Symlink our AGS config to ~/.config/ags
  home.file.".config/ags" = {
    source = ../../ags;
    recursive = true;
  };
}
