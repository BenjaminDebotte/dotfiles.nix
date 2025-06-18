{ inputs, pkgs, ... }:

{
  home.packages = [ pkgs.hyprlandPlugins.hyprsplit ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
       # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit # Doesn't work
       # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces # Doesn't work
       # pkgs.hyprlandPlugins.hyprsplit
       (pkgs.callPackage ./hyprland-plugins.nix {})
    ];
  };


}
