{ inputs, ... }:


{
  programs.home-manager.enable = true;

  programs.ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
IdentityFile ~/.ssh/id_ed25519
User bdebotte

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
      '';
  };

  programs.git.signing.format = "openpgp";

  services.ssh-agent.enable = true;

  programs.google-chrome = {
   enable = true;
  };

  programs.firefox = {
    enable = true;

    profiles.bdebotte = {
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
            ublock-origin
        ];
    };
  };

}
