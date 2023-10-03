return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  cmd = { "TSUpdateSync" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = "all",
    highlight = { enable = true },
    indent = { enabled = true },
  },
}
