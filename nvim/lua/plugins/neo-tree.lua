return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>fe", "<cmd>Neotree source=filesystem position=left toggle=true reveal=true<cr>", desc = "File Tree" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true
      }
    }
  }
}
