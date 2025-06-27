{ inputs, ... }:


{
  programs.home-manager.enable = true;

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
