vim.opt.winborder = "rounded"
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
	{ src = "https://github.com/folke/flash.nvim" },
})

vim.cmd("set completeopt+=noselect")
vim.lsp.enable({
	"lua_ls"
})

vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

require "mason".setup()
require "vague".setup({ transparent = true })
require "flash".setup()

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
		border = "rounded",
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

vim.keymap.set('n', "<leader>o", ':update<CR>:source<CR>')
vim.keymap.set('n', "<leader>h", builtin.help_tags)
vim.keymap.set('n', "<leader>ff", builtin.find_files)
vim.keymap.set({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
vim.keymap.set('n', "<leader>ps", '<cmd>lua vim.pack.update()<CR>')
vim.keymap.set('n', '<leader>w', vim.lsp.buf.format)
vim.keymap.set({ "n" }, "<leader>sm", builtin.man_pages, {desc = "man pages"})
vim.keymap.set({ "n" }, "<leader>sr", builtin.lsp_references, {desc = "Show References"})
vim.keymap.set({ "n" }, "<leader>sd", builtin.diagnostics, {desc = "Show Diagnostics"})
vim.keymap.set({ "n" }, "<leader>si", builtin.lsp_implementations, {desc = "Jump to Implementation"})
vim.keymap.set({ "n" }, "<leader>sT", builtin.lsp_type_definitions, {desc = "Jump to Definition"})
vim.keymap.set({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find, {desc = "Current Buffer Fuzzy"})
vim.keymap.set({ "n" }, "<leader>st", builtin.builtin)
vim.keymap.set({ "n" }, "<leader>sc", builtin.git_bcommits)
vim.keymap.set({ "n" }, "<leader>sk", builtin.keymaps, {desc = "Show keymaps"})



vim.cmd('colorscheme ' .. default_color)



local Flash = require("flash")

---@param opts Flash.Format
local function format(opts)
  -- always show first and second label
  return {
    { opts.match.label1, "FlashMatch" },
    { opts.match.label2, "FlashLabel" },
  }
end

Flash.jump({
  search = { mode = "search" },
  label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
  pattern = [[\<]],
  action = function(match, state)
    state:hide()
    Flash.jump({
      search = { max_length = 0 },
      highlight = { matches = false },
      label = { format = format },
      matcher = function(win)
        -- limit matches to the current label
        return vim.tbl_filter(function(m)
          return m.label == match.label and m.win == win
        end, state.results)
      end,
      labeler = function(matches)
        for _, m in ipairs(matches) do
          m.label = m.label2 -- use the second label
        end
      end,
    })
  end,
  labeler = function(matches, state)
    local labels = state:labels()
    for m, match in ipairs(matches) do
      match.label1 = labels[math.floor((m - 1) / #labels) + 1]
      match.label2 = labels[(m - 1) % #labels + 1]
      match.label = match.label1
    end
  end,
})
