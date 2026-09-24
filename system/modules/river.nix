{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mySystem.desktop.river = {
    enable = lib.mkEnableOption "River Wayland compositor";
  };

  config = lib.mkIf config.mySystem.desktop.river.enable {
    programs.river = {
      enable = true;
      extraPackages = with pkgs; [
        swaybg
        kanshi
        wlr-randr
        grim
        slurp
        pamixer
        brightnessctl
        gammastep
        kitty
        libnotify
        mako
        qt5.qtwayland
        qt6.qtwayland
        swayidle
        swaylock-effects
        sway-audio-idle-inhibit
        wlogout
        wl-clipboard
        rofi
        rofi-bluetooth
        rofi-pass-wayland
        rofi-file-browser
        pinentry-rofi
        waybar
      ];
    };
  };
}
