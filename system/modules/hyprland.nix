{ config, inputs, pkgs, ... }:

{
  # Full definition in users/hyprland.nix
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlandPlugins.hyprsplit
    kitty
    libnotify
    mako
    qt5.qtwayland
    qt6.qtwayland
    swayidle
    swaylock-effects
    wlogout
    wl-clipboard
    rofi
    rofi-bluetooth
    rofi-pass-wayland
    rofi-file-browser
    pinentry-rofi
    waybar
  ];
}
