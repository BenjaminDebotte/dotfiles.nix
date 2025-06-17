{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    plugins = [
      pkgs.hyprlandPlugins.hyprsplit
    ];
  };
}
