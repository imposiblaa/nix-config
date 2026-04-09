{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Your custom packages
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#Chip' (needs sudo)
    nixosConfigurations = {
      Chip = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          stylix.nixosModules.stylix
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager entrypoint
    # Run WITHOUT sudo: home-manager switch --flake .#cn@Chip
    homeConfigurations = {
      "cn@Chip" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          stylix.homeModules.stylix
          ./home-manager/home.nix
          # Stylix config for standalone HM (mirrors nixos/stylix.nix)
          {
            stylix = {
              enable = true;
              image = ./wallpaper1.png;
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
            };
          }
        ];
      };
    };
  };
}
