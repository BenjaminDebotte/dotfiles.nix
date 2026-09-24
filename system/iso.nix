# WHAT: Minimal bootable NixOS Live USB installer configuration.
# WHY:  Provides a self-contained rescue/installer image without bloating the main workstation config.
# HOW:  Imports minimal installation-cd modules, enables flakes, and provides basic recovery tools.
# WHERE: Instantiated in `flake.nix` under `nixosConfigurations.iso`.
{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
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
