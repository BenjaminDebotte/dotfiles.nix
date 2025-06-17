{ config, pkgs, pkgs-unstable, lib, inputs, ... }:

{
  imports = [
    ./user
  ];
  
  home.username = "bdebotte";
  home.homeDirectory = "/home/bdebotte";
  home.stateVersion = "25.05";
}

