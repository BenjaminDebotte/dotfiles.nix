# Technical Plan: NixOS Architecture Modernization

## Initiative Overview
Decompose the dotfiles architecture into three sequential capability stages:
1. `overlays`: Centralize overlays in `nix/overlays.nix` and unify package consumption (`pkgs.*`).
2. `integrated-hm`: Integrate Home Manager into NixOS modules, removing dual-dispatch boilerplate from `flake.nix`.
3. `feature-flags`: Introduce declarative `mySystem.*` options to toggle system & user components.

---

## Architecture & Dependency Flow

```
[ Module 1: overlays ]
       │
       ▼
[ Module 2: integrated-hm ]
       │
       ▼
[ Module 3: feature-flags ]
```

---

## Phase Details

### Phase 1: Overlays Centralization (`overlays`)
- **Files touched:**
  - `nix/overlays.nix` (create)
  - `home/user/neovim.nix` (update to `pkgs.neovim-nightly`)
  - `home/user/packages.nix` (update to `pkgs.herdr`, `pkgs.unstable.vesktop`)
  - `home/user/programs.nix` (update to `pkgs.firefox-addons`)
- **Risks & Mitigation:**
  - *Risk:* Overlays not propagating to standalone Home Manager before Phase 2.
  - *Mitigation:* Wire `nixpkgs.overlays` in both `flake.nix` and module imports.

### Phase 2: Integrated Home Manager (`integrated-hm`)
- **Files touched:**
  - `system/configuration.nix` (import HM module and wire user `bdebotte`)
  - `home/default.nix` (adapt for NixOS module usage: `home-manager.users.bdebotte = { ... }`)
  - `flake.nix` (remove `homeConfigurations.bdebotte`, remove `extraSpecialArgs`)
  - `Taskfile.yml` (update tasks if needed)
- **Risks & Mitigation:**
  - *Risk:* State version or username collision between NixOS and HM.
  - *Mitigation:* Explicitly configure `home-manager.useGlobalPkgs = true;` and `home-manager.useUserPackages = true;`.

### Phase 3: Declarative Feature Flags (`feature-flags`)
- **Files touched:**
  - `system/modules/` (declare `options.mySystem.*`)
  - `system/configuration.nix` (simplify into a declarative feature manifest)
- **Risks & Mitigation:**
  - *Risk:* Breaking existing desktop/audio configurations.
  - *Mitigation:* Set sensible defaults / keep enable flags matching current active features.

---

## Verification Checkpoints
- **Checkpoint 1 (after Phase 1):** `nix eval .#homeConfigurations.bdebotte.activationPackage.drvPath` succeeds with new overlays.
- **Checkpoint 2 (after Phase 2):** `nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath` evaluates full integrated system + home closure. `nix flake check` passes.
- **Checkpoint 3 (after Phase 3):** All feature flags evaluate cleanly and `nix fmt` passes.
