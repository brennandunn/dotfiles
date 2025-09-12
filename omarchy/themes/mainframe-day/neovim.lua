return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").colorscheme("dawn")
		vim.cmd("colorscheme rose-pine")
	end,
}
