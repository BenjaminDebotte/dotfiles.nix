{ config, pkgs, ... }:

{
users.users.bdebotte = {
     isNormalUser = true;
     createHome = true;
     shell = pkgs.zsh;
     extraGroups = [ 
     	"wheel" 
        "qemu"
        "kvm"
        "libvirtd"
        "networkmanager"
     ]; 
   };
}
