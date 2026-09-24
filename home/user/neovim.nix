{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaPackages = ps: [
      ps.lua
      ps.luarocks-nix
      ps.magick
    ];
    extraPackages = with pkgs; [
      imagemagick

      # pkgs.next-ls
      # vimPlugins.elixir-tools-nvim
      ruff

      # Formatters
      # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
      nodePackages.prettier
      shfmt
      stylelint
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
  };
}
