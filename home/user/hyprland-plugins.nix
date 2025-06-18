{
  lib,
  fetchFromGitHub,
  gnumake,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprsplit";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "v0.49.0";
    hash = "sha256-0jrsiUoQi/VXM2Ji7YTOEYDYYlBI2C3ZbgQpYoAEVKI=";
  };

  # any nativeBuildInputs required for the plugin
  inherit (hyprland) nativeBuildInputs;
  # nativeBuildInputs = [gnumake];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [hyprland] ++ hyprland.buildInputs;
  buildFlags = ["all"];


  meta = {
    homepage = "https://github.com/shezdy/hyprsplit/";
    description = "awesome / dwm like workspaces for hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
