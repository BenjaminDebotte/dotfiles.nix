let
  userName = "Benjamin Debotte";
  email = "benjamin.debotte@gmail.com";
in {
  programs.git = {
    enable = true;
    inherit userName;
    userEmail = email;
  };
}
