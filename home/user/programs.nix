{ inputs, ... }:


{
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    compression = true;
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
      User bdebotte
      '';
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
      };
    };
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
