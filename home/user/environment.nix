{ lib, inputs, pkgs, pkgs-unstable, ... }:

with lib; let
  hyprPluginDir = pkgs.symlinkJoin {
      name = "hyprland-plugins";
      paths = [
        pkgs.hyprlandPlugins.hyprsplit
      ];
    };
in
{
  home.sessionVariables = {

	     BROWSER = "google-chrome";
	     CLUTTER_BACKEND = "wayland";
	     EDITOR = "nvim";
	     GTK_USE_PORTAL = "1";
	     MOZ_ENABLE_WAYLAND = "1";
	     NIXOS_OZONE_WL = "1";
	     NIXOS_XDG_OPEN_USE_PORTAL = "1";
       HYPR_PLUGIN_DIR = hyprPluginDir;
	     QT_AUTO_SCREEN_SCALE_FACTOR = "1";
	     QT_QPA_PLATFORM = "wayland-egl";
	     QT_QPA_PLATFORMTHEME = "gtk3";
	     QT_SCALE_FACTOR = "1";
	     QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
	     SDL_VIDEODRIVER = "wayland";
	     TERMINAL = "kitty";
	     WLR_DRM_DEVICES = "/dev/dri/card1";
	     WLR_NO_HARDWARE_CURSORS = "1"; 
	     WLR_RENDERER = "vulkan";
	     XDG_BIN_HOME = "\${HOME}/.local/bin";
	     XDG_CACHE_HOME = "\${HOME}/.cache";
	     XDG_CONFIG_HOME = "\${HOME}/.config";
	     XDG_CURRENT_DESKTOP = "Hyprland";
	     XDG_DATA_HOME = "\${HOME}/.local/share";
	     XDG_SESSION_DESKTOP = "Hyprland";
	     XDG_SESSION_TYPE = "wayland";
       GTK_CSD = "0";
       GTK_THEME="Catppuccin-Macchiato-Compact-Blue-Dark";
       XCURSOR_SIZE = "32";
  };
}
