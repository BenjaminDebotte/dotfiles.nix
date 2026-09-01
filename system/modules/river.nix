{ pkgs, ... }:

{
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
    ];
  };
}
