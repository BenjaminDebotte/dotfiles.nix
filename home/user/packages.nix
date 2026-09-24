{pkgs, ...}: {
  home.packages = [
    # Network
    pkgs.protonvpn-gui
    pkgs.python313Packages.proton-vpn-network-manager
    # Dev stuff
    pkgs.herdr
    pkgs.gcc
    pkgs.kubectl
    pkgs.k9s
    pkgs.go
    pkgs.lua
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pip
      python-pkgs.requests
    ]))
    pkgs.lazygit
    pkgs.tree-sitter
    pkgs.imagemagick
    pkgs.usbutils
    pkgs.sops
    pkgs.age

    # Language Servers
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    pkgs.yaml-language-server
    pkgs.lua-language-server

    # Bluetooth
    pkgs.blueberry

    # Social
    pkgs.unstable.vesktop

    # Gaming
    # pkgs.heroic
    # pkgs.umu-launcher
    # pkgs.steam
    # pkgs.steam-run
    # (pkgs.lutris.override {
    #  extraPkgs = pkgs: [
    #  pkgs.wineWowPackages.stable
    #  pkgs.winetricks
    #  ];
    #  })

    # Downloads
    pkgs.qbittorrent

    # Media
    pkgs.vlc

    # Utils
    pkgs.ethtool
    pkgs.viewnior

    # Nix and System Management Tools
    pkgs.go-task
    pkgs.nix-output-monitor
    pkgs.nvd
    pkgs.nix-tree
    pkgs.manix
    pkgs.comma
    pkgs.statix
    pkgs.deadnix
  ];
}
