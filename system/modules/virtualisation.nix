{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mySystem.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation with Podman and Libvirt";
  };

  config = lib.mkIf config.mySystem.virtualisation.enable {
    virtualisation = {
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;

        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };

      podman = {
        enable = true;

        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      qemu
      spice
      spice-gtk
      spice-protocol
      virt-manager
      virt-viewer
      win-spice
      win-virtio
    ];
  };
}
