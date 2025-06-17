{
    description = "bdebotte NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
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

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.bdebotte = import ./home/default.nix;
                extraSpecialArgs = {
                  inherit inputs;
                  inherit pkgs;
                  inherit pkgs-unstable;
                };
              };
            }
        ];
        specialArgs = {
          inherit pkgs-unstable;
        };
      };


    };
}
