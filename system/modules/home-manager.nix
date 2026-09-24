# WHAT: System-level Home Manager integration module.
# WHY:  Unifies OS and user configuration into a single atomic deployment (`nh os switch`),
#       shares global `pkgs` (with overlays applied), and eliminates duplicate evaluation.
# HOW:  Enables `useGlobalPkgs` and `useUserPackages`, loads `pi.homeModules.default`,
#       and wires `users.bdebotte` to `./home`.
# WHERE: Imported by `system/modules/default.nix` and loaded into `nixosConfigurations.nixos`.
{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.pi.homeModules.default
    ];
    users.bdebotte = import ../../home;
  };
}
