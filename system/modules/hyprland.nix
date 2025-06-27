{ config, pkgs, ... }:

{
  # Full definition in users/hyprland.nix
  programs.hyprland.enable = true;

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
