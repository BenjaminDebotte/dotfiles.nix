{
  description = "bdebotte NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, split-monitor-workspaces,  ... }@inputs:
    let 
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; }; # Despite it being defined in system/modules
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
        ./system/configuration.nix 

      ];
      specialArgs = {
        inherit inputs;
      };
    };

    homeConfigurations = {
      bdebotte = home-manager.lib.homeManagerConfiguration
      {
          inherit pkgs;
          modules = [ ./home ];
          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs;
            inherit pkgs-unstable;
          };
      };
    };
  };
}
