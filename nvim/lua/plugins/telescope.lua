local findRef = function() 
  require("telescope.builtin").lsp_references()
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.2",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  cmd = "Telescope",
  keys = {
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fr", findRef, desc = "LSP References" },
  },
}
