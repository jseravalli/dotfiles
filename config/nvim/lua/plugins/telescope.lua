return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep'  },
	config = function()
		local builtin = require('telescope.builtin')

		-- LSP document symbols (classes, methods, functions in current file)
		vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find symbols in current file' })
	end,
}
