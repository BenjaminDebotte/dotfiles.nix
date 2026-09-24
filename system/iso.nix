{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

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
