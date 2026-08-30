{ config, pkgs, ... }:

{
  documentation.nixos.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
	settings = {
		warn-dirty = false;
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
    trusted-users = [ "root" "bdebotte" ];

    substituters = [
      "https://pi.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
	};

	gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};
  };
}
