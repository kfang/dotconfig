return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    init = function()
      -- Inject site data directory into runtimepath
      local ts_dir = vim.fn.stdpath('data') .. '/site/'
      vim.opt.runtimepath:append(ts_dir)
    end,
  }
}
