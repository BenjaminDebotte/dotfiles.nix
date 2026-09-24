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
