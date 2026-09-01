{ pkgs, ... }:

{
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      rivertile
      swaybg
      kanshi
      wlr-randr
      grim
      slurp
      pamixer
      brightnessctl
    ];
  };
}
