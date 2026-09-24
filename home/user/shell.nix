{config, ...}: let
  myAliases = {
    # System CLI replacements
    docker-compose = "podman-compose";
    cat = "bat";
    ls = "eza --icons=always";
    vim = "nvim";
    cdot = "cd ~/.dotfiles";

    # --- Git Shorthands ---
    g = "git";
    gst = "git status";
    gco = "git checkout";
    gcb = "git checkout -b";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -v";
    gcm = "git commit -m";
    gp = "git push";
    gpl = "git pull";
    gl = "git log --oneline --graph --decorate";
    gd = "git diff";

    # --- NixOS & Home Manager Rebuilds (Unified) ---
    nrs = "nh os switch ~/.dotfiles";
    rebuild = "nh os switch ~/.dotfiles";
    nrb = "nh os boot ~/.dotfiles";
    nrt = "nh os test ~/.dotfiles";
    ndry = "nh os test ~/.dotfiles";

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
    nrollback = "sudo nixos-rebuild switch --rollback";
    ndiff = "nix store diff-closures /run/booted-system /run/current-system";

    # --- Clean & Garbage Collection ---
    ngc = "nix-collect-garbage --delete-older-than 7d";
    nsudogc = "sudo nix-collect-garbage --delete-older-than 7d";
    nopt = "nix-store --optimise";
    fullClean = "nix-collect-garbage --delete-older-than 7d && sudo nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot && nix-store --optimise";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;

    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };

    completionInit = ''
      autoload -Uz compinit
      zcompdump="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
      mkdir -p "''${zcompdump:h}"

      # Fast compinit with cache (skip slow compaudit on read-only Nix store)
      if [[ -s "$zcompdump" && (! -s "$zcompdump.zwc" || "$zcompdump" -nt "$zcompdump.zwc") ]]; then
        compinit -C -d "$zcompdump"
        { zcompile "$zcompdump" } &!
      elif [[ -s "$zcompdump" && $(find "$zcompdump" -mtime -1 2>/dev/null) ]]; then
        compinit -C -d "$zcompdump"
      else
        compinit -i -d "$zcompdump"
        { zcompile "$zcompdump" } &!
      fi
    '';

    shellAliases = myAliases;

    initContent = ''
      # --- Snappy Escape and Vi Mode Handling ---
      # 150ms timeout for escape sequences: fast mode switching without key fragmentation
      KEYTIMEOUT=15

      # Terminal application keypad mode (smkx/rmkx) & cursor shape handling
      function zle-line-init() {
        (( ''${+terminfo[smkx]} )) && echoti smkx
        echo -ne '\e[5 q' # Beam cursor in insert mode
      }
      function zle-line-finish() {
        (( ''${+terminfo[rmkx]} )) && echoti rmkx
        echo -ne '\e[2 q' # Block cursor on exit
      }
      function zle-keymap-select() {
        case $KEYMAP in
          vicmd) echo -ne '\e[2 q' ;;      # Block cursor in normal mode
          viins|main) echo -ne '\e[5 q' ;; # Beam cursor in insert mode
        esac
      }
      zle -N zle-line-init
      zle -N zle-line-finish
      zle -N zle-keymap-select

      # --- History Substring / Beginning Search ---
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      # --- Comprehensive Dual-Mode Keybindings (viins & vicmd) ---
      for keymap in viins vicmd; do
        # Up Arrow (ANSI + SS3 + Terminfo)
        bindkey -M $keymap "^[[A" up-line-or-beginning-search
        bindkey -M $keymap "^[OA" up-line-or-beginning-search
        [[ -n "''${terminfo[kcuu1]}" ]] && bindkey -M $keymap "''${terminfo[kcuu1]}" up-line-or-beginning-search

        # Down Arrow (ANSI + SS3 + Terminfo)
        bindkey -M $keymap "^[[B" down-line-or-beginning-search
        bindkey -M $keymap "^[OB" down-line-or-beginning-search
        [[ -n "''${terminfo[kcud1]}" ]] && bindkey -M $keymap "''${terminfo[kcud1]}" down-line-or-beginning-search

        # Left Arrow
        bindkey -M $keymap "^[[D" backward-char
        bindkey -M $keymap "^[OD" backward-char
        [[ -n "''${terminfo[kcub1]}" ]] && bindkey -M $keymap "''${terminfo[kcub1]}" backward-char

        # Right Arrow
        bindkey -M $keymap "^[[C" forward-char
        bindkey -M $keymap "^[OC" forward-char
        [[ -n "''${terminfo[kcuf1]}" ]] && bindkey -M $keymap "''${terminfo[kcuf1]}" forward-char

        # Home
        bindkey -M $keymap "^[[H" beginning-of-line
        bindkey -M $keymap "^[OH" beginning-of-line
        bindkey -M $keymap "^[[1~" beginning-of-line
        bindkey -M $keymap "^[[7~" beginning-of-line
        [[ -n "''${terminfo[khome]}" ]] && bindkey -M $keymap "''${terminfo[khome]}" beginning-of-line

        # End
        bindkey -M $keymap "^[[F" end-of-line
        bindkey -M $keymap "^[OF" end-of-line
        bindkey -M $keymap "^[[4~" end-of-line
        bindkey -M $keymap "^[[8~" end-of-line
        [[ -n "''${terminfo[kend]}" ]] && bindkey -M $keymap "''${terminfo[kend]}" end-of-line

        # Delete
        bindkey -M $keymap "^[[3~" delete-char
        [[ -n "''${terminfo[kdch1]}" ]] && bindkey -M $keymap "''${terminfo[kdch1]}" delete-char

        # Backspace
        bindkey -M $keymap "^?" backward-delete-char
        bindkey -M $keymap "^H" backward-delete-char

        # Word Navigation (Ctrl+Left / Ctrl+Right)
        bindkey -M $keymap "^[[1;5D" backward-word
        bindkey -M $keymap "^[[5D" backward-word
        bindkey -M $keymap "^[[1;5C" forward-word
        bindkey -M $keymap "^[[5C" forward-word
      done

      # --- Additional Insert Mode Ergonomics ---
      bindkey -M viins "^A" beginning-of-line
      bindkey -M viins "^E" end-of-line
      bindkey -M viins "^K" kill-line
      bindkey -M viins "^U" backward-kill-line
      bindkey -M viins "^W" backward-kill-word
      bindkey -M viins "^R" history-incremental-search-backward
    '';
  };
}
