{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  # Stylix color variables mapped to semantic SCSS names
  colors = config.lib.stylix.colors;
  colorsScss = pkgs.writeText "_colors.scss" ''
    // Auto-generated from Stylix base16 scheme — do not edit
    $bg:      #${colors.base00};
    $bg1:     #${colors.base01};
    $bg2:     #${colors.base02};
    $bg3:     #${colors.base03};
    $fg:      #${colors.base05};
    $fg1:     #${colors.base04};
    $fg2:     #${colors.base06};
    $red:     #${colors.base08};
    $orange:  #${colors.base09};
    $yellow:  #${colors.base0A};
    $green:   #${colors.base0B};
    $aqua:    #${colors.base0C};
    $blue:    #${colors.base0D};
    $purple:  #${colors.base0E};
    $brown:   #${colors.base0F};

    $popup-opacity: ${toString config.stylix.opacity.popups};
    $font-family: "${config.stylix.fonts.monospace.name}";
  '';

  # Build ags with all required GTK4 + astal libraries properly wrapped
  agsWrapped =
    pkgs.runCommand "ags-wrapped" {
      nativeBuildInputs = [pkgs.makeWrapper];
      buildInputs = [];
    } ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.ags}/bin/ags $out/bin/ags \
        --prefix GI_TYPELIB_PATH : "${lib.makeSearchPathOutput "lib" "lib/girepository-1.0" (with pkgs; [
        gtk4
        gdk-pixbuf
        graphene
        pango
        harfbuzz
        cairo
        glib
        gobject-introspection
        astal.astal4
        astal.hyprland
        astal.mpris
        astal.battery
        astal.network
        astal.wireplumber
        astal.bluetooth
        astal.tray
        networkmanager
      ])}"
    '';
in {
  home.packages = [agsWrapped pkgs.blueman];

  home.file.".config/ags" = {
    source = ../../ags;
    recursive = true;
  };

  home.file.".config/ags/_colors.scss".source = colorsScss;
}
