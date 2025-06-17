{ config, pkgs, lib, ... }:

{
   boot = {
        kernelParams = ["nohibernate" "ipv6.disable=1"];
        tmp.cleanOnBoot = true;
        supportedFilesystems = ["ntfs"];
        loader = {
         	efi.canTouchEfiVariables = false;
        	systemd-boot = {
        		enable = true;
			consoleMode = "auto";
			editor = false;
        	};
        	timeout = 5;
        };
   };

}
