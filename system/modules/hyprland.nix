{ config, pkgs, ... }:

{
    programs.hyprland = {
        enable = true;

        xwayland = {
            enable = true;
        };
        

        portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
      hyprpaper
      kitty
      libnotify
      mako
      qt5.qtwayland
      qt6.qtwayland
      swayidle
      swaylock-effects
      wlogout
      wl-clipboard
      wofi
      waybar
    ];
}
