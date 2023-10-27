{ pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = builtins.readFile nvim/init.lua;
      plugins = with pkgs.vimPlugins; [
        commentary
        gruvbox
        idris2-vim
        null-ls-nvim
        nvim-lspconfig
        nvim-lsp-ts-utils
        plenary-nvim
        suda-vim
        telescope-nvim
        vim-elixir
        vim-fugitive
        vim-gitgutter
        vim-gnupg
        vim-hcl
        vim-nix
        vim-repeat
        vim-shellcheck
        vim-surround
        vim-terraform
        vim-test
        vim-unimpaired
      ];
    };
  };
}
