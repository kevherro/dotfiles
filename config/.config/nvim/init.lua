vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- basics
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false
vim.o.smartindent = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.colorcolumn = '80'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.confirm = true
vim.o.clipboard = 'unnamedplus'

vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- go files: tabstop 8 (go convention)
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'go',
	callback = function()
		vim.bo.tabstop = 8
		vim.bo.shiftwidth = 8
	end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*',
	command = [[%s/\s\+$//e]],
})

-- format on save for LSP-attached buffers
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function(ev)
		local clients = vim.lsp.get_clients({ bufnr = ev.buf })
		for _, c in ipairs(clients) do
			if c:supports_method('textDocument/formatting') then
				vim.lsp.buf.format({ async = false, bufnr = ev.buf })
				return
			end
		end
	end,
})

-- organize imports on save (go)
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.go',
	callback = function()
		local params = vim.lsp.util.make_range_params(0, 'utf-16')
		params.context = { only = { 'source.organizeImports' } }
		local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
	end,
})

-- lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		'git', 'clone', '--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

	'NMAC427/guess-indent.nvim',

	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},

	{
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			'nvim-telescope/telescope-ui-select.nvim',
		},
		config = function()
			local t = require('telescope')
			t.setup({
				extensions = {
					['ui-select'] = require('telescope.themes').get_dropdown(),
				},
			})
			pcall(t.load_extension, 'fzf')
			pcall(t.load_extension, 'ui-select')

			local b = require('telescope.builtin')
			vim.keymap.set('n', '<leader>sf', b.find_files)
			vim.keymap.set('n', '<leader>sg', b.live_grep)
			vim.keymap.set('n', '<leader>sd', b.diagnostics)
		end,
	},

	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	{
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},

	{
		'saghen/blink.cmp',
		event = 'VimEnter',
		version = '1.*',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				version = '2.*',
				build = (function()
					if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then return end
					return 'make install_jsregexp'
				end)(),
				dependencies = {
					{
						'rafamadriz/friendly-snippets',
						config = function()
							require('luasnip.loaders.from_vscode').lazy_load()
						end,
					},
				},
			},
		},
		opts = {
			keymap = { preset = 'default' },
			appearance = { nerd_font_variant = 'mono' },
			completion = { documentation = { auto_show = true } },
			sources = { default = { 'lsp', 'path', 'snippets' } },
			snippets = { preset = 'luasnip' },
			fuzzy = { implementation = 'lua' },
			signature = { enabled = true },
		},
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', opts = {} },
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			{ 'j-hui/fidget.nvim',       opts = {} },
		},
		config = function()
			-- keymaps
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
				callback = function(ev)
					local map = function(k, fn)
						vim.keymap.set('n', k, fn, { buffer = ev.buf })
					end
					map('grn', vim.lsp.buf.rename)
					map('gra', vim.lsp.buf.code_action)
					map('grr', require('telescope.builtin').lsp_references)
					map('gri', require('telescope.builtin').lsp_implementations)
					map('grd', require('telescope.builtin').lsp_definitions)
				end,
			})

			-- capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok, blink = pcall(require, 'blink.cmp')
			if ok and blink.get_lsp_capabilities then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = 'Replace' },
							diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},

				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							usePlaceholders = true,
							staticcheck = true,
							vulncheck = 'Imports',
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							directoryFilters = { '-.git', '-node_modules', '-vendor' },
						},
					},
				},

				rust_analyzer = {
					settings = {
						['rust-analyzer'] = {
							cargo = { allFeatures = true, buildScripts = { enable = true } },
							check = { command = 'clippy' },
							procMacro = { enable = true },
							imports = { granularity = { group = 'module' }, prefix = 'self' },
						},
					},
				},
			}

			-- mason installs binaries
			local ensure = vim.tbl_keys(servers)
			require('mason-tool-installer').setup({ ensure_installed = ensure })

			require('mason-lspconfig').setup({
				ensure_installed = {},
				automatic_installation = false,
			})

			-- nvim 0.11+ native lsp config/enable
			for name, cfg in pairs(servers) do
				cfg = vim.tbl_deep_extend('force', { capabilities = capabilities }, cfg or {})
				vim.lsp.config(name, cfg)
				vim.lsp.enable(name)
			end

			-- sourcekit-lsp (swift) (non-mason)
			vim.lsp.config('sourcekit', {
				cmd = { 'xcrun', 'sourcekit-lsp' },
				capabilities = capabilities,
				root_markers = { 'Package.swift', '.xcodeproj', '.xcworkspace', '.git' },
			})
			vim.lsp.enable('sourcekit')
		end,
	},

	{
		'folke/todo-comments.nvim',
		event = 'VimEnter',
		opts = { signs = false },
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			ensure_installed = {
				'bash', 'diff', 'go', 'gomod', 'gosum', 'gowork',
				'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
				'query', 'typescript', 'vim', 'vimdoc',
				'zig', 'swift', 'rust', 'toml',
			},
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
		},
	},

	{
		'tjdevries/express_line.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-web-devicons' },
		config = function()
			local el = require('el')
			local ext = require('el.extensions')
			el.setup({
				generator = function(_, buf)
					return {
						ext.mode, ' ',
						ext.file, ' ',
						ext.git_branch,
						'%=', ext.lsp_status, ' ',
						ext.filetype, ' %l:%c',
					}
				end,
			})
		end,
	},
})
