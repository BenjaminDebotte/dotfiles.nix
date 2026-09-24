{
  config,
  lib,
  ...
}: {
  options.mySystem.hardware.laptop = {
    enable = lib.mkEnableOption "Laptop power management (TLP, thermald)";
  };

  config = {
    services = {
      dbus.enable = true;
      picom.enable = false;
      openssh.enable = true;
      spice-vdagentd.enable = true;
      tailscale.enable = true;

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
          wayland.enable = true;
        };
      };
    };

    services.power-profiles-daemon.enable = lib.mkIf config.mySystem.hardware.laptop.enable false;
    services.tlp = lib.mkIf config.mySystem.hardware.laptop.enable {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Disable PCIe power management on AC to avoid wifi latency, enable on battery
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };
    services.thermald.enable = lib.mkIf config.mySystem.hardware.laptop.enable true;
  };
}
