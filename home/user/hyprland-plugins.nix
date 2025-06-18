{
  lib,
  fetchFromGitHub,
  make,
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
    hash = "sha256-331e0a447f66aab066462856e029148969de3c012729955d35defce75171cadc";
  };

  # any nativeBuildInputs required for the plugin
  nativeBuildInputs = [make];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [];

  meta = {
    homepage = "https://github.com/shezdy/hyprsplit/";
    description = "awesome / dwm like workspaces for hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
