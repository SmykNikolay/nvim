return {
  {
    "s1n7ax/nvim-window-picker",
    config = function()
      require("window-picker").setup({
        -- ваши параметры конфигурации для window-picker
        autoselect_one = true,
        include_current_win = false,
        filter_rules = {
          -- фильтры для выбора окон
          bo = {
            filetype = { "neo-tree", "quickfix" },
            buftype = { "terminal" },
          },
        },
      })
    end,
  },
}
