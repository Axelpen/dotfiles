vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.winborder = bold



vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "master" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",              version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/smoka7/hop.nvim" },
	{ src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim" },
})

vim.cmd("set completeopt+=noselect")
vim.lsp.enable({
	'lua_ls',
	'omnisharp',
	'clangd'
})

vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

require "mason".setup()
require "hop".setup()
require "vague".setup({ transparent = true })

-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, { remap = true })
vim.keymap.set('', 'F', function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
end, { remap = true })
vim.keymap.set('', 't', function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set('', 'T', function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })




vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'markdown', 'lua', 'c_sharp', 'typst', 'typescript', 'javascript', 'c', 'cpp', 'glsl', 'zig', 'python', "typescriptreact", "react", },
	callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"icon",
	},
	float = {
		max_width = 0.3,
		max_height = 0.6,
		border = "bold",
	},
})

local telescope = require("telescope")
local default_color = "vague"
telescope.setup({
	defaults = {
		preview = { treesitter = true },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"", -- top
			"", -- right
			"", -- bottom
			"", -- left
			"", -- top-left
			"", -- top-right
			"", -- bottom-right
			"", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})

-- telescope.load_extension("ui-select")
--
local builtin = require("telescope.builtin")

vim.keymap.set('i', "jk", "<ESC>")

vim.keymap.set('n', "<leader>o", ':update<CR>:source<CR>')
vim.keymap.set('n', "<leader>h", builtin.help_tags)
vim.keymap.set('n', "<leader>ff", builtin.find_files)
vim.keymap.set({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
vim.keymap.set('n', "<leader>ps", '<cmd>lua vim.pack.update()<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set({ "n" }, "<leader>sm", builtin.man_pages, { desc = "man pages" })
vim.keymap.set({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Show References" })
vim.keymap.set({ "n" }, "<leader>sd", builtin.diagnostics, { desc = "Show Diagnostics" })
vim.keymap.set({ "n" }, "<leader>si", builtin.lsp_implementations, { desc = "Jump to Implementation" })
vim.keymap.set({ "n" }, "<leader>sT", builtin.lsp_type_definitions, { desc = "Jump to Definition" })
vim.keymap.set({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find, { desc = "Current Buffer Fuzzy" })
vim.keymap.set({ "n" }, "<leader>st", builtin.builtin)
vim.keymap.set({ "n" }, "<leader>sf", builtin.live_grep, { desc = "Live Grep"})
vim.keymap.set({ "n" }, "<leader>sc", builtin.git_bcommits)
vim.keymap.set({ "n" }, "<leader>sk", builtin.keymaps, { desc = "Show keymaps" })



vim.cmd('colorscheme ' .. default_color)
