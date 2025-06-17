{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    glib 
    gsettings-desktop-schemas
    nwg-look
  ];
}
