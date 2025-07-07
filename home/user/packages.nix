{ pkgs, pkgs-unstable, ... }:

{


  home.packages = [

# Hyprland
    pkgs-unstable.hyprlandPlugins.hyprsplit

# Network
      pkgs.protonvpn-gui
      pkgs.python313Packages.proton-vpn-network-manager
# Dev stuff
      pkgs.gcc
      pkgs.go
      pkgs.lua
      (pkgs.python3.withPackages (python-pkgs: [
                                  python-pkgs.pip
                                  python-pkgs.requests
      ]))
      pkgs.lazygit
      pkgs.imagemagick
      pkgs.usbutils

# Language Servers
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      pkgs.yaml-language-server
      pkgs.lua-language-server

# Bluetooth
      pkgs.blueberry

# Social
      pkgs.vesktop

# Gaming
      pkgs.heroic
      pkgs.umu-launcher
      pkgs.steam
      pkgs.steam-run
      (pkgs.lutris.override {
       extraPkgs = pkgs: [
       pkgs.wineWowPackages.stable
       pkgs.winetricks
       ];
       })

# Downloads
  pkgs.qbittorrent

# Utils
    pkgs.zsh-powerlevel10k
    pkgs.ethtool
    pkgs.viewnior
    pkgs.catppuccin-cursors.macchiatoGreen
    pkgs.catppuccin-gtk
    pkgs.papirus-folders


    ];
}
