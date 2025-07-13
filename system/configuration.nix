{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules 
  ];

  system.stateVersion = "25.05"; 
}

