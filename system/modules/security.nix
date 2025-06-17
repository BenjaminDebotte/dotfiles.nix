{ pkgs, ... }: 

{
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.swaylock.fprintAuth = false;
  security.sudo.extraRules = [{
  	users = [ "bdebotte" ];
	commands = [
	{
	  command = "ALL";
	  options = [ "NOPASSWD" ];
	}
	];
  }];
}
