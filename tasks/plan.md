# Implementation Plan: River Wayland Compositor (DWM Workflow)

## Overview
This plan transitions the desktop environment from Hyprland's rigid 1:1 container workspace model to **River (`riverwm`)**, restoring an authentic DWM workflow on Wayland with 32-bit tag bitmasks (assigning windows to multiple tags, viewing arbitrary combinations of tags simultaneously, per-monitor independent tags) and classic dynamic master-and-stack tiling via `rivertile`. The setup maintains 100% keybinding parity, preserves the existing Waybar theme/modules, fixes portal configuration for screen sharing, and retains Hyprland alongside River for safe session coexistence in SDDM.

## Architecture Decisions
- **Compositor & Layout Engine:** River with `rivertile`. River provides native 32-bit tag bitmasks via `riverctl`, while `rivertile` handles DWM-style dynamic master/stack layouts with zoom and mfact/nmaster controls.
- **Session Coexistence & Declarative NixOS Module:** Add `system/modules/river.nix` with `programs.river.enable = true;` so SDDM registers both River and Hyprland.
- **Portal & Session Environment Clean-up:** Remove hardcoded `XDG_CURRENT_DESKTOP = "Hyprland"` from `home/user/environment.nix` and configure multi-compositor portal support (`xdg-desktop-portal-wlr` for River, `xdg-desktop-portal-hyprland` for Hyprland) in `system/modules/programs.nix`.
- **Executable River Init & Dotfile Conventions:** Store the River initialization script in `home/config/river/init`, mapped via `home/user/config.nix` with `executable = true`.
- **Waybar River Integration:** Add a dedicated River Waybar configuration (`home/config/waybar/river-config.jsonc`) and update `home/config/waybar/style.css` with `#tags` and `#layout` styling that matches the existing Everforest theme.
- **Display, Wallpaper & Utilities:** Use `swaybg` for wallpaper, `kanshi` / `wlr-randr` for display management, and `grim` + `slurp` for screenshots.

## Task List

### Phase 1: NixOS System Modules & Environment Foundations
- [ ] Task 1: Create `system/modules/river.nix` and update `system/modules/default.nix`
- [ ] Task 2: Configure multi-compositor portals in `system/modules/programs.nix` and clean up desktop environment variables in `home/user/environment.nix`

### Checkpoint: System & Portal Configuration
- [ ] `nix-instantiate --parse` and flake checks pass for system modules.

### Phase 2: River Configuration & Keybindings (DWM Workflow)
- [ ] Task 3: Implement `home/config/river/init` with full DWM tag bitmasks, `rivertile` master-stack controls, app shortcuts, media/audio bindings, and startup daemons
- [ ] Task 4: Map River configuration in `home/user/config.nix` with `executable = true` and add necessary user packages

### Checkpoint: River Init & Dotfile Links
- [ ] River init script syntax is valid; Home Manager file declarations are correct.

### Phase 3: Status Bar (Waybar) & Display Configuration
- [ ] Task 5: Create `home/config/waybar/river-config.jsonc` and update `home/config/waybar/style.css` for River tags/layout
- [ ] Task 6: Add display and wallpaper configuration (`home/config/kanshi/config`) and verify end-to-end integration

### Checkpoint: Complete
- [ ] All acceptance criteria met across all tasks.
- [ ] Code formatted with standard 2-space indentation / `nix fmt`.
- [ ] Flake evaluation and checks pass cleanly.

## Risks and Mitigations
| Risk | Impact | Mitigation |
| :--- | :--- | :--- |
| Portal mismatch breaks screen sharing | Medium | Explicitly route portal configs by compositor (`river.default = ["wlr" "gtk"]`, `Hyprland.default = ["hyprland" "gtk"]`) and remove hardcoded session variables. |
| River `init` not marked executable | High | Explicitly specify `executable = true` in Home Manager `home.file.".config/river/init"`. |
| Waybar workspace styling breaks during switch | Low | Keep Hyprland Waybar config intact and provide a dedicated `river-config.jsonc` that shares `style.css`. |
| Breaking existing Hyprland session | High | Purely additive changes; Hyprland config files remain untouched. |
