return {
    {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()	
	    require('nvim-treesitter').install { 'c', 'python', 'sql', 'bash', 'ssh_config', 'yaml', 'markdown', 'make', 'lua', 'terraform', 'jinja' }


	vim.api.nvim_create_autocmd("FileType", {
	  pattern = "*",
	  callback = function()
	    pcall(vim.treesitter.start) -- pcall to avoid errors on unsupported filetypes
	  end,
	})

	-- Make `import` visually distinct from the module name it imports,
	-- without hardcoding a colour. We re-link the Tree-sitter capture
	-- to the standard Vim group `Include`, which every colourscheme styles.
	local function fix_import_hl()
	  vim.api.nvim_set_hl(0, "@keyword.import.python", { link = "@keyword.function" })
	end

	-- Apply now (colourscheme has already loaded due to its higher priority)
	fix_import_hl()

	-- Re-apply whenever the colourscheme changes
	vim.api.nvim_create_autocmd("ColorScheme", {
	  callback = fix_import_hl,
	})
    end
    }
}
