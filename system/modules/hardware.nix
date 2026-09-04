_:

{
  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;

    # Enable firmware updates via fwupd (already enabled by nixos-hardware, but good to be explicit/declarative)
    # Allows updating BIOS/Firmware via `fwupdmgr`
  };
}
