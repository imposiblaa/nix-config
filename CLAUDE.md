# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Deploy Commands

```bash
# NixOS system rebuild (requires sudo)
sudo nixos-rebuild switch --flake .#Chip
# or: ./update.sh

# Home Manager rebuild (no sudo)
nix shell nixpkgs#home-manager --command home-manager switch --flake .#cn@Chip
# or: ./hmrebuild.sh

# Format nix files
nix fmt
```

The formatter is `alejandra` (configured in flake.nix). There are no tests or linters configured.

AGS changes are deployed via `hmrebuild.sh` — Home Manager copies `ags/` to `~/.config/ags/`. To restart the bar after deploy: `ags quit; ags run --gtk4 ~/.config/ags/app.ts`.

## Architecture

This is a NixOS + Home Manager flake for a single host (`Chip`) and user (`cn`). The desktop environment is Hyprland with an AGS v2 (Astal) status bar.

### Flake Structure

- `flake.nix` — Entry point. Defines `nixosConfigurations.Chip` and `homeConfigurations."cn@Chip"`. Both apply Stylix for theming.
- `nixos/configuration.nix` — System-level config. Imports Home Manager as a NixOS module, so `sudo nixos-rebuild` also rebuilds the home config.
- `home-manager/home.nix` — User-level config. Imports modules from `modules/home-manager/`.
- `modules/nixos/` — System modules: nvidia, hyprland (session), stylix, vim.
- `modules/home-manager/` — User modules: hyprland (keybinds/settings), ags, vscode, freecad.
- `overlays/default.nix` — Exposes custom packages (`pkgs/`) and `pkgs.unstable` from nixpkgs-unstable.

### Theming

Stylix with gruvbox-dark-hard base16 scheme. It auto-themes most apps (hyprland, kitty, waybar, wofi, mako, hyprlock). AGS is **not** auto-themed — instead, `modules/home-manager/ags.nix` generates `_colors.scss` from Stylix's base16 palette and writes it to `~/.config/ags/_colors.scss`. AGS styles import this file. VSCode is explicitly excluded from Stylix theming.

### AGS Bar (ags/)

TypeScript + GTK4 shell using Astal (AGS v2). Entry point: `app.ts`. Uses `astal/gtk4` bindings.

- `bar/` — Bar components: `Bar.tsx` (layout), `Workspaces.tsx`, `Media.tsx`, `SystemInfo.tsx` (right-side pills for cpu, ram, network, bluetooth, volume, battery, clock, weather)
- `popups/` — Click-to-open popup windows for each system pill. All popups use `PopupWindow.tsx` as a wrapper and are managed by `popupManager.ts` (handles mutual exclusion — only one popup open at a time).
- `style.scss` — All styles. Imports `_colors.scss` (generated at build time, not checked in).
- `icons.ts` — Nerd Font icon constants.

The bar is launched by Hyprland's `exec-once`: `ags run --gtk4 ~/.config/ags/app.ts`. AGS is wrapped in `modules/home-manager/ags.nix` to include GTK4 and Astal typelib paths in `GI_TYPELIB_PATH`.

When testing AGS it is acceptable to run directly on the pre-home-manager files located here using `ags run --gtk4 ./ags/app.ts`

### Hyprland Config

Split across two files:
- `modules/nixos/hyprland.nix` — Enables the Hyprland session at the system level.
- `modules/home-manager/hyprland.nix` — All user settings: keybinds, monitor layout, window rules, animations, exec-once autostart. Uses `split-monitor-workspaces` plugin (6 workspaces per monitor). Also configures waybar (kept as fallback), mako, hypridle, and hyprlock.

## Thinks to Consider
- nix will not see any files created until they are added to git (failure to add newly created files to git WILL cause errors)
