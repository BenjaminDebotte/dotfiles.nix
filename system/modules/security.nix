_: {
  security = {
    polkit.enable = true;
    pam.services.swaylock = {
      fprintAuth = false;
    };
    sudo.extraRules = [
      {
        users = ["bdebotte"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
