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
local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,
  })
end)

-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "eslint",
    "lua_ls",
    "terraformls",
    "tflint",
    "tsserver",
  },
  handlers = {
    lsp.default_setup
  },
})

-- lsp.ensure_installed({
--   "eslint",
--   "lua_ls",
--   "terraformls",
--   "tflint",
--   "tsserver",
-- })
-- 
-- lsp.setup_servers({ "eslint", "lua_ls", "terraformls", "tflint", "tsserver" });


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
vim.wo.number = true
