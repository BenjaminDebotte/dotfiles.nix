{ pkgs, ... }:

let
  agentSkillsRepo = pkgs.fetchFromGitHub {
    owner = "addyosmani";
    repo = "agent-skills";
    rev = "main";
    hash = "sha256-cETMU2Pfha4cXWTORfu0wXJXOTrAmmEk3GDY2lAoQnw=";
  };
in
{
  programs.pi.coding-agent = {
    enable = true;
  };

  home.file = {
    ".agents/skills".source = "${agentSkillsRepo}/skills";
    ".agents/agents".source = "${agentSkillsRepo}/agents";
  };
}
