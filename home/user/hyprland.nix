{ inputs, pkgs, split-monitor-workspaces, ... }:

{

  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = true;
    xwayland.enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };


}
