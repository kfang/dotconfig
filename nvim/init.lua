-- setup lazy nvim ------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath);
vim.g.mapleader = " "
require("lazy").setup("plugins")

-- setup lsp-zero --------------------------------------------------------------
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
  "eslint",
  "lua_ls",
  "terraformls",
  "tflint",
  "tsserver",
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- setup nvim-cmp --------------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
  mapping = {
   ["<CR>"] = cmp.mapping(function (fallback)
     if (cmp.visible()) then
       if not cmp.get_selected_entry() then
         cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
       else
         cmp.confirm()
       end
     else
       fallback()
     end
   end, { "i", "s", "c", }),
 }
})

--------------------------------------------------------------------------------

vim.cmd.colorscheme "tokyonight-moon"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 20
