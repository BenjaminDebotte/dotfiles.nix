# Tasks: River Wayland Setup (DWM Workflow)

## Phase 1: NixOS System Modules & Environment Foundations

### Task 1: Create `system/modules/river.nix` and register in `system/modules/default.nix`
**Description:** Add system-level River configuration enabling `programs.river.enable = true` and adding core Wayland tools (`rivertile`, `swaybg`, `kanshi`, `wlr-randr`, `grim`, `slurp`, `pamixer`, `brightnessctl`) so River appears in SDDM alongside Hyprland.

**Acceptance criteria:**
- [x] `system/modules/river.nix` is created with `programs.river.enable = true;` and necessary system packages.
- [x] `system/modules/default.nix` imports `./river.nix`.
- [x] No existing system modules (including `hyprland.nix` and `hardware-configuration.nix`) are broken.

**Verification:**
- [x] `nix-instantiate --parse system/modules/river.nix`
- [x] `nix-instantiate --parse system/modules/default.nix`

**Dependencies:** None
**Files likely touched:**
- `system/modules/river.nix`
- `system/modules/default.nix`
**Estimated scope:** Small (2 files)

---

### Task 2: Configure multi-compositor portals and clean up session environment
**Description:** Update `system/modules/programs.nix` to properly route `xdg.portal` requests based on the running compositor (`wlr` for River, `hyprland` for Hyprland), and remove hardcoded `XDG_CURRENT_DESKTOP = "Hyprland"` and `XDG_SESSION_DESKTOP = "Hyprland"` from `home/user/environment.nix`.

**Acceptance criteria:**
- [x] `system/modules/programs.nix` configures `xdg.portal` with `wlr.enable = true` and multi-compositor desktop configs.
- [x] `home/user/environment.nix` does not hardcode `XDG_CURRENT_DESKTOP` or `XDG_SESSION_DESKTOP` so SDDM sets them correctly for River or Hyprland.
- [x] Wayland flags, editor, browser, and theme environment variables remain intact.

**Verification:**
- [x] `nix-instantiate --parse system/modules/programs.nix`
- [x] `nix-instantiate --parse home/user/environment.nix`

**Dependencies:** Task 1
**Files likely touched:**
- `system/modules/programs.nix`
- `home/user/environment.nix`
**Estimated scope:** Small (2 files)

---

## Checkpoint: System & Portal Configuration
- [x] `nix flake check` or parsing checks pass for all modified NixOS modules.
- [x] System module changes follow declarative rules and 2-space indentation.

---

## Phase 2: River Configuration & Keybindings (DWM Workflow)

### Task 3: Implement River `init` script (`home/config/river/init`)
**Description:** Write the full River initialization script in bash/riverctl providing complete keybinding parity with the user's workflow:
1. Classic DWM 1–9 tag bitmask operations (`set-focused-tags`, `set-view-tags`, `toggle-focused-tags`, `toggle-view-tags`, focus all tags `511`, tag view all `511`).
2. Classic DWM master-and-stack dynamic layout via `rivertile`:
   - Focus next/prev view (`Super + j/k`)
   - Swap next/prev view (`Super + Shift + j/k`)
   - Zoom / swap with master (`Super + Space` and `Super + Return`)
   - Master ratio split adjustments (`Super + h/l`)
   - Master window count increments (`Super + i/d`)
   - Floating / Fullscreen toggles (`Super + Shift + Space`, `Super + v`, `Super + f`)
   - Mouse move and resize bindings (`Super + Left / Right mouse button`)
3. App launch shortcuts (`kitty`, `code`, `$BROWSER`, `yazi`, `neomutt`, `rofi -show drun`, `rofi-pass`, `wlogout`).
4. Media, audio (`pamixer`), brightness (`brightnessctl`), and screenshot (`grim`/`slurp`) shortcuts.
5. Autostart daemons: `kanshi`, `swaybg`, `mako`, `waybar` (with River config), `rivertile`, and Polkit gnome authentication agent.

**Acceptance criteria:**
- [x] `home/config/river/init` is created with a complete, well-commented shell configuration for `riverctl`.
- [x] All 1–9 DWM bitmask tag mappings (single tag, multi-tag view, assign tag, multi-tag assign, view all) are implemented.
- [x] All master/stack layout commands communicate with `rivertile`.
- [x] All application and media shortcuts from `bind.conf` are accurately ported.

**Verification:**
- [x] `bash -n home/config/river/init` passes syntax validation.

**Dependencies:** Task 2
**Files likely touched:**
- `home/config/river/init`
**Estimated scope:** Small (1 file)

---

### Task 4: Map River configuration in `home/user/config.nix` & packages
**Description:** Update `home/user/config.nix` to link `home/config/river/init` as an executable file (`.config/river/init`) in `~/.config/river/` and ensure all required user utilities are declared.

**Acceptance criteria:**
- [x] `home/user/config.nix` maps `.config/river/init` with `executable = true`.
- [x] Home Manager links `.config/kanshi` if separate config file is present.

**Verification:**
- [x] `nix-instantiate --parse home/user/config.nix`

**Dependencies:** Task 3
**Files likely touched:**
- `home/user/config.nix`
**Estimated scope:** Small (1 file)

---

## Checkpoint: River Init & Dotfile Links
- [x] `bash -n home/config/river/init` returns 0.
- [x] Home Manager configuration parses cleanly.

---

## Phase 3: Status Bar (Waybar) & Display Configuration

### Task 5: Create `home/config/waybar/river-config.jsonc` & update `style.css`
**Description:** Create a dedicated Waybar configuration for River (`river-config.jsonc`) that uses `river/tags` and `river/layout` while preserving all hardware modules (battery, backlight, audio, cpu, clock, tray, etc.). Update `home/config/waybar/style.css` to style `#tags button`, `#tags button.focused`, `#tags button.occupied`, `#tags button.urgent`, and `#layout` with the existing Everforest color palette.

**Acceptance criteria:**
- [x] `home/config/waybar/river-config.jsonc` is created with `river/tags`, `river/layout`, `river/window`, and all right-hand status modules.
- [x] `home/config/waybar/style.css` contains styling rules for River tags and layout consistent with the `#workspaces` design.
- [x] Existing `config.jsonc` remains intact for Hyprland.

**Verification:**
- [x] JSON syntax check: `python3 -m json.tool home/config/waybar/river-config.jsonc > /dev/null` or equivalent JSON parser.

**Dependencies:** Task 4
**Files likely touched:**
- `home/config/waybar/river-config.jsonc`
- `home/config/waybar/style.css`
**Estimated scope:** Small (2 files)

---

### Task 6: Add Kanshi display profile & verify end-to-end configuration
**Description:** Create `home/config/kanshi/config` with the laptop display profile (`eDP-1` highres@highrr / default) and run repository-wide verification (`nix fmt`, `nix flake check`, and git status check) to guarantee zero syntax or evaluation errors.

**Acceptance criteria:**
- [x] `home/config/kanshi/config` created.
- [x] Formatting is applied across all touched `.nix` files using `nix fmt`.
- [x] `nix flake check` or `nix-instantiate` succeeds with zero errors.

**Verification:**
- [x] `nix fmt`
- [x] `nix flake check` (or evaluation of NixOS and Home Manager configurations).

**Dependencies:** Task 5
**Files likely touched:**
- `home/config/kanshi/config`
**Estimated scope:** Small (1 file)

---

## Checkpoint: Final Review & Acceptance
- [x] All tasks in `tasks/todo.md` checked.
- [x] Declarative NixOS and Home Manager configuration complete and formatted.
- [x] Ready for user review.
