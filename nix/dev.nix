{
  inputs,
  pkgs,
  system,
}: let
  treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
    projectRootFile = "flake.nix";
    programs.alejandra.enable = true;
    # programs.shfmt.enable = true; # Bash
    # programs.stylua.enable = true; # Lua
    # programs.prettier.enable = true; # Markdown
  };

  preCommitCheck = inputs.git-hooks-nix.lib.${system}.run {
    src = ../.;
    hooks = {
      treefmt = {
        enable = true;
        package = treefmtEval.config.build.wrapper;
      };
      statix.enable = true;
      deadnix.enable = true;
    };
  };
in {
  formatter = treefmtEval.config.build.wrapper;
  pre-commit-check = preCommitCheck;
  devShell = pkgs.mkShell {
    inherit (preCommitCheck) shellHook;
    buildInputs = preCommitCheck.enabledPackages;
  };
}
