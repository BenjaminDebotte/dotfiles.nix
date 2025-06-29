{ config, pkgs, ... }:

{
  services = {
    dbus.enable = true;
    picom.enable = true;
    openssh.enable = true;
    spice-vdagentd.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:super";

    };
    displayManager = {
      sddm = {
        enable = true;
        # theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
        wayland.enable = true;
        settings = {
          Autologin = {
            User = "bdebotte";
          };
        };
      };
    };
  };
}
