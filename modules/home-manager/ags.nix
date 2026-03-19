{ pkgs, lib, inputs, ... }:

let
  # Build ags with all required GTK4 + astal libraries properly wrapped
  agsWrapped = pkgs.runCommand "ags-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
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
        astal.tray
        networkmanager
      ])}"
  '';
in
{
  home.packages = [ agsWrapped ];

  home.file.".config/ags" = {
    source = ../../ags;
    recursive = true;
  };
}
