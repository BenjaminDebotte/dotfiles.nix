_:

{
  services = {
    dbus.enable = true;
    picom.enable = false;
    openssh.enable = true;
    spice-vdagentd.enable = true;
    tailscale.enable = true;

    # Laptop specific
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
      };
    };

    thermald.enable = true;
    # end of laptop specific

    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:super";

    };
    displayManager = {
      defaultSession = "river";
      autoLogin.enable = true;
      autoLogin.user = "bdebotte";

      sddm = {
        enable = true;
        # theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
        wayland.enable = true;
      };
    };
  };
}
