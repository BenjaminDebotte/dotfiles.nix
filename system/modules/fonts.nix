{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome 
    jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
