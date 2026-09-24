# WHAT: Repository development environment, formatters, and git pre-commit hooks.
# WHY:  Keeps meta-repository developer tooling isolated from OS system and user configurations.
# HOW:  Evaluates treefmt-nix (Alejandra) and git-hooks-nix (deadnix, statix, treefmt),
#       exporting the formatter wrapper, pre-commit checks, and a devShell.
# WHERE: Imported by `flake.nix` into `formatter`, `checks`, and `devShells`.
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
