return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    --"nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  lazy = false,
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
  },
  opts = {
    window = {
      position = "float",
    },
    filesystem = {
      filtered_items = { hide_dotfiles = false, hide_gitignored = true },
    },
  },
}
