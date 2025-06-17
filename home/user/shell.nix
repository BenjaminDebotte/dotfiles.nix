{ config, pkgs, ... }:
let 
  myAliases = {
    docker-compose = "podman-compose";
    cat = "bat";
    ls = "eza --icons=always";
    vim = "nvim";

    fullClean = '' 
        nix-collect-garbage --delete-old

        sudo nix-collect-garbage -d

        sudo /run/current-system/bin/switch-to-configuration boot
    '';
    rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
    fullRebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/ && home-manager switch --flake ~/.dotfiles/ -b backup";
    homeRebuild = "home-manager switch --flake ~/.dotfiles/ -b backup";
};
in
{
  programs = {
	zsh = {
		enable = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		enableCompletion = true;
		initContent = '' 
            		eval "$(zoxide init --cmd cd zsh)"
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
			theme = "powerlevel10k/powerlevel10k";
			plugins = [
				"git"
				"history"
				"wd"
        "tmux"
			# {
			#           name = "zsh-powerlevel10k";
			# 	  src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
			# 	  file = "powerlevel10k.zsh-theme";
			#         }
			];
		};
	};
  };
}

