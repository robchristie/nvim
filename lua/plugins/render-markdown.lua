return {
   'MeanderingProgrammer/render-markdown.nvim',
   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
   ---@module 'render-markdown'
   ---@type render.md.UserConfig
   opts = {
      anti_conceal = {
         -- This enables hiding added text on the line the cursor is on.
         enabled = false,
      },
   },
}
