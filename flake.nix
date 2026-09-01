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
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    pi.url = "github:lukasl-dev/pi.nix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      treefmt-nix,
      git-hooks-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

      # Eval treefmt
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
        # programs.shfmt.enable = true; # Bash
        # programs.stylua.enable = true; # Lua
        # programs.prettier.enable = true; # Markdown
      };

      # Eval pre-commit hooks
      pre-commit-check = git-hooks-nix.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            package = treefmtEval.config.build.wrapper;
          };
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.pre-commit-check = pre-commit-check;
      devShells.${system}.default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
        buildInputs = pre-commit-check.enabledPackages;
      };

      nixosConfigurations = {
        # Ta configuration actuelle
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/configuration.nix
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        # NOUVEAU : La configuration pour créer ta clé USB bootable
        iso = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Le module magique qui transforme cette config en ISO
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

            # Quelques configurations utiles pour ton Live USB
            (
              { pkgs, ... }:
              {
                # Activer les flakes par défaut sur l'ISO pour pouvoir installer directement
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                # Outils indispensables pour l'installation sur le nouveau laptop
                environment.systemPackages = with pkgs; [
                  git
                  neovim
                  parted
                ];
              }
            )
          ];
        };
      };

      homeConfigurations = {
        bdebotte = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            inputs.pi.homeModules.default
            ./home
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs;
            inherit pkgs-unstable;
          };
        };
      };
    };
}
