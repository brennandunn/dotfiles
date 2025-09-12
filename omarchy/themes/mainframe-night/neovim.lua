return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").colorscheme("moon")
		vim.cmd("colorscheme rose-pine")
	end,
}
