let configDir = ../config;
in
{
  home.file = {
      ".config/nvim" = { source = "${configDir}/nvim"; recursive = true; };
      ".config/wallpapers".source = "${configDir}/wallpapers";
      ".config/kitty".source = "${configDir}/kitty";
      ".config/neofetch".source = "${configDir}/neofetch";
      ".config/hypr".source = "${configDir}/hypr";
      ".config/wlogout".source = "${configDir}/wlogout";
      ".config/waybar".source = "${configDir}/waybar";
      ".config/btop".source = "${configDir}/btop";
      ".config/rofi".source = "${configDir}/rofi";
      ".config/mako".source = "${configDir}/mako";
      ".p10k.zsh".source = "${configDir}/zsh/.p10k.zsh";
  };
}
