{pkgs, ...}: {
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
}
