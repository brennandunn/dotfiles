return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "dawn",
      dark_variant = "moon",

      styles = {
        transparency = true
      }
    })
    vim.cmd("colorscheme rose-pine-dawn")
  end
}
