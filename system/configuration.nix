{...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  mySystem = {
    desktop.river.enable = true;
    virtualisation.enable = true;
    hardware.laptop.enable = true;
  };

  system.stateVersion = "25.05";
}
