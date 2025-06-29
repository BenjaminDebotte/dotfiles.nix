{ pkgs, pkgs-unstable, ... }:

{
  

  home.packages = [
    
    pkgs-unstable.hyprlandPlugins.hyprsplit

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

    # Language Servers
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    pkgs.yaml-language-server
    pkgs.lua-language-server

    # Bluetooth
    pkgs.blueberry

    # Social
    pkgs.vesktop

    # Gaming
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
    pkgs.catppuccin-cursors.macchiatoBlue
    pkgs.catppuccin-gtk
    pkgs.papirus-folders
  ];
}
