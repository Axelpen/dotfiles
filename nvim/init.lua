vim.g.mapleader = " "

vim.opt.tabstop = 1
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.showtabline = 2
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.cursorcolumn = false
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "bold"
vim.opt.laststatus = 3


vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "v0.10.0" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",              version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-cmdline" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/smoka7/hop.nvim" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim" },
})


require("vague").setup({ transparent = true })
vim.cmd.colorscheme("vague")


require("mason").setup()





local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git" },
	capabilities = capabilities,
	settings = { Lua = { runtime = { version = "LuaJIT" } } },
})

vim.lsp.enable({ "lua_ls", "omnisharp", "clangd" })

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	completion = {
		autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}),
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "c", "cpp", "c_sharp", "python", "markdown" },
	callback = function()
		vim.treesitter.start()
	end,
})


local telescope = require("telescope")

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
		},
	},
})

local builtin = require("telescope.builtin")


require("hop").setup()

local hop = require("hop")
local directions = require("hop.hint").HintDirection

vim.keymap.set("", "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR })
end)

vim.keymap.set("", "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR })
end)


require("oil").setup({
	columns = { "icon" },
	float = {
		max_width = 0.3,
		max_height = 0.6,
		border = "bold",
	},
})


require("actions-preview").setup({
	backend = { "telescope" },
})

-- Keymaps

vim.keymap.set("i", "jk", "<ESC>")

vim.keymap.set("n", "<leader>h", builtin.help_tags)
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>sf", builtin.live_grep)
vim.keymap.set("n", "<leader>ss", builtin.current_buffer_fuzzy_find)

vim.keymap.set("n", "<leader>sr", builtin.lsp_references)
vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
vim.keymap.set("n", "<leader>si", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>sk", builtin.keymaps)

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>")
vim.keymap.set("n", "<leader>v", "<Cmd>edit $MYVIMRC<CR>")
