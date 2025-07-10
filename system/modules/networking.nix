{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  # https://haruska.com/til/disable-network-card-offloading-in-nixos
  systemd.services."disable-offload-enp19s0" = {
    description = "Disable offload (GRO/GSO/TSO/...) on enp19s0";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp19s0 gro off gso off tso off";
    };
    wantedBy = [ "network-pre.target" ];
  };
}
