{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
    pkgs.qt6.qtdeclarative
  ];
}