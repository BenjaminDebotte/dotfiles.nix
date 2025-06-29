{
    imports = [
        ./git.nix
        ./gtk.nix
        ./shell.nix
        ./config.nix
        ./packages.nix
        ./programs.nix
        ./environment.nix
        ./neovim.nix
    ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);

      permittedInsecurePackages = [
      ];
    };
  };
}
