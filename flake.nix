{
  description = "bdebotte NixOS";

  # Binary cache
  nixConfig = {
    extra-substituters = [
      "https://pi.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    pi.url = "github:lukasl-dev/pi.nix";

    herdr = {
      url = "github:herdrdev/herdr-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    overlays = import ./nix/overlays.nix {inherit inputs;};
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    dev = import ./nix/dev.nix {inherit inputs pkgs system;};
  in {
    formatter.${system} = dev.formatter;
    checks.${system}.pre-commit-check = dev.pre-commit-check;
    devShells.${system}.default = dev.devShell;

    nixosConfigurations = {
      # Configuration actuelle
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-9300
          home-manager.nixosModules.home-manager
          ./system/configuration.nix
        ];
      };

      # Configuration pour créer la clé USB bootable
      iso = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./system/iso.nix
        ];
      };
    };
  };
}
