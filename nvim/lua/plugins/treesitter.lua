return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    auto_install = false,
    ensure_installed = {
      "bash",
      "java",
      "javascript",
      "json",
      "json5",
      "lua",
      "scala",
      "terraform",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    sync_install = true,
  }
}
