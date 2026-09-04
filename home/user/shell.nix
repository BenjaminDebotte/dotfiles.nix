{ pkgs, ... }:
let
  myAliases = {
    # System CLI replacements
    docker-compose = "podman-compose";
    cat = "bat";
    ls = "eza --icons=always";
    vim = "nvim";
    cdot = "cd ~/.dotfiles";

    # --- NixOS & Home Manager Rebuilds ---
    nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles/#nixos";
    rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/#nixos";
    nrb = "sudo nixos-rebuild boot --flake ~/.dotfiles/#nixos";
    nrt = "sudo nixos-rebuild test --flake ~/.dotfiles/#nixos";
    ndry = "sudo nixos-rebuild dry-build --flake ~/.dotfiles/#nixos";

    hms = "home-manager switch --flake ~/.dotfiles/#bdebotte -b backup";
    homeRebuild = "home-manager switch --flake ~/.dotfiles/#bdebotte -b backup";

    fullRebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/#nixos && home-manager switch --flake ~/.dotfiles/#bdebotte -b backup";
    allRebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/#nixos && home-manager switch --flake ~/.dotfiles/#bdebotte -b backup";

    # --- Flake Operations ---
    nfc = "nix flake check ~/.dotfiles";
    flakeCheck = "nix flake check ~/.dotfiles";
    nfmt = "nix fmt ~/.dotfiles";
    nfu = "nix flake update --flake ~/.dotfiles";
    flakeUpdate = "nix flake update --flake ~/.dotfiles";
    nshow = "nix flake show ~/.dotfiles";
    ns = "nix search nixpkgs";

    # --- Generations & Rollbacks ---
    ngen = "nixos-rebuild list-generations";
    hgen = "home-manager generations";
    nrollback = "sudo nixos-rebuild switch --rollback";
    ndiff = "nix store diff-closures /run/booted-system /run/current-system";

    # --- Clean & Garbage Collection ---
    ngc = "nix-collect-garbage --delete-older-than 7d";
    nsudogc = "sudo nix-collect-garbage --delete-older-than 7d";
    nopt = "nix-store --optimise";
    fullClean = "nix-collect-garbage --delete-older-than 7d && sudo nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot && nix-store --optimise";
  };
in
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

      initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      shellAliases = myAliases;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      oh-my-zsh = {
        enable = true;
        custom = "$HOME/.oh-my-custom";
        plugins = [
          "git"
          "history"
          "wd"
          "tmux"
          # {
          #           name = "zsh-powerlevel10k";
          # 	  src = "${pkgs.zsh-powerlevel11k}/share/zsh-powerlevel10k/";
          # 	  file = "powerlevel10k.zsh-theme";
          #         }
        ];
      };
    };
  };
}
