return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
			require("rose-pine").setup({
				--- @usage 'auto'|'main'|'moon'|'dawn'
				variant = "auto",
				dark_variant = "main",

		      		-- ✅ Transparent background
		      		disable_background = true,
		      		disable_float_background = true,

		    	  styles = {
				bold = true,
				italic = true,
				transparency = true,
		      		},
		    	})
			vim.cmd("colorscheme rose-pine")
	end
}
