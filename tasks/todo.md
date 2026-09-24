# Task List: NixOS Architecture Modernization

## Module 1: Overlays (`overlays`)
- [x] Task 1.1: Create `nix/overlays.nix` exposing `unstable`, `neovim-nightly`, `herdr`, and `firefox-addons` on `pkgs`.
  - Acceptance: `nix/overlays.nix` exports an overlay list taking `{ inputs }` using canonical hostPlatform and static allowUnfree.
  - Verify: `nix-instantiate --parse nix/overlays.nix`
  - Files: `nix/overlays.nix`

- [x] Task 1.2: Refactor package references in `home/user/` to use `pkgs.*`.
  - Acceptance: `home/user/neovim.nix`, `packages.nix`, and `programs.nix` no longer reference `inputs.*` or `pkgs-unstable`.
  - Verify: `git grep "inputs\." home/` and `git grep "pkgs-unstable" home/` return zero hits.
  - Files: `home/user/neovim.nix`, `home/user/packages.nix`, `home/user/programs.nix`

## Module 2: Integrated Home Manager (`integrated-hm`)
- [x] Task 2.1: Integrate Home Manager into NixOS system configuration.
  - Acceptance: `home-manager.nixosModules.home-manager` is loaded in `nixosConfigurations.nixos` with `useGlobalPkgs = true`, `useUserPackages = true`, and `sharedModules = [ inputs.pi.homeModules.default ]`.
  - Verify: `nix eval .#nixosConfigurations.nixos.config.home-manager.users.bdebotte.home.username` evaluates to `"bdebotte"`.
  - Files: `system/modules/home-manager.nix`, `system/modules/default.nix`, `home/user/default.nix`, `flake.nix`

- [x] Task 2.2: Streamline `flake.nix` and `Taskfile.yml`.
  - Acceptance: `homeConfigurations` removed from `flake.nix`, `flake.nix` reduced to pure router, `Taskfile.yml` cleaned.
  - Verify: `nix fmt` passes without errors.
  - Files: `flake.nix`, `Taskfile.yml`

## Module 3: Declarative Feature Flags (`feature-flags`)
- [x] Task 3.1: Define structured `mySystem` options for desktop and services.
  - Acceptance: Options defined under `mySystem` for desktop, theme, audio, and user packages.
  - Verify: `nix eval .#nixosConfigurations.nixos.config.mySystem` evaluates cleanly.
  - Files: `system/modules/`, `system/configuration.nix`

- [x] Task 3.2: Format all files and run final validation.
  - Acceptance: All nix files formatted with treefmt/alejandra, full closure evaluates cleanly.
  - Verify: `nix fmt`, `nix flake check`, and derivation path evaluation pass.
  - Files: all touched files
