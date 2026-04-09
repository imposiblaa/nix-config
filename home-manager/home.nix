# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    #../modules/home-manager/awesome.nix
    ../modules/home-manager/hyprland.nix
    ../modules/home-manager/ags.nix
    ../modules/home-manager/freecad.nix
    ../modules/home-manager/vscode.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "cn";
    homeDirectory = "/home/cn";

    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.brave
      pkgs.sxiv
      pkgs.claude-code
      pkgs.temurin-bin
      pkgs.mpv
    ];
  };

  programs.git = {
    enable = true;
    settings.user.email = "imposiblaa@gmail.com";
    settings.user.name = "Colin Nelson";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  services.udiskie = {
    enable = true;
    automount = true;
    tray = "always";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
