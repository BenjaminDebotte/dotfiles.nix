{ pkgs, ... }:

{
  wayland.windowManager.hyprland.plugins = [
        pkgs.hyprlandPlugins.hyprsplit
      ];
}
