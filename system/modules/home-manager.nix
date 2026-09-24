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
