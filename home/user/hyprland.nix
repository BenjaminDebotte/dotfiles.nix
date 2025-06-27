{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = true;
    xwayland.enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };

}
