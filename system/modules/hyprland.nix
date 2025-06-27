{ config, inputs, pkgs, pkgs-unstable, ... }:

{
  # Full definition in users/hyprland.nix
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages =  [
    pkgs.hyprpaper
    pkgs-unstable.hyprlandPlugins.hyprsplit
    pkgs.kitty
    pkgs.libnotify
    pkgs.mako
    pkgs.qt5.qtwayland
    pkgs.qt6.qtwayland
    pkgs.swayidle
    pkgs.swaylock-effects
    pkgs.wlogout
    pkgs.wl-clipboard
    pkgs.wofi
    pkgs.waybar
  ];
}
