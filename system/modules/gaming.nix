{ config, pkgs, ... }:

# NOTE: Pour plus tard ? https://github.com/Jovian-Experiments/Jovian-NixOS/blob/development/modules/steam/steam.nix

{
  programs.gamemode.enable = true;

  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };
}
