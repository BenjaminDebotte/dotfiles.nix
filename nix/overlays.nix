# WHAT: Centralized Nixpkgs overlays factory.
# WHY:  Avoids manual argument threading (extraSpecialArgs) and allows all system
#       and Home Manager modules to access external flake packages directly via `pkgs.*`.
# HOW:  Attaches `pkgs.unstable.*` via a scoped nixpkgs-unstable instance, plus
#       `pkgs.neovim-nightly`, `pkgs.herdr`, and `pkgs.firefox-addons`.
# WHERE: Imported by `flake.nix` and wired into `nixpkgs.overlays` in `system/modules/nixsettings.nix`.
{inputs}: [
  (_: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    neovim-nightly = inputs.neovim-nightly-overlay.packages.${prev.stdenv.hostPlatform.system}.default;
    herdr = inputs.herdr.packages.${prev.stdenv.hostPlatform.system}.default;
    firefox-addons = inputs.firefox-addons.packages.${prev.stdenv.hostPlatform.system};
  })
]
