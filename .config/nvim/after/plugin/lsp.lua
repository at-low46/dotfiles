local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }

		-- LSP actions
		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		vim.keymap.set('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', opts)

		-- Diagnostics
		vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
		vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
		vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
	end
})

local function lsp_settings()
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = 'rounded' },
	})

	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = 'rounded' }
	)

	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = 'rounded' }
	)

	local command = vim.api.nvim_create_user_command

	command('LspWorkspaceAdd', function()
		vim.lsp.buf.add_workspace_folder()
	end, { desc = 'Add folder to workspace' })

	command('LspWorkspaceList', function()
		vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = 'List workspace folders' })

	command('LspWorkspaceRemove', function()
		vim.lsp.buf.remove_workspace_folder()
	end, { desc = 'Remove folder from workspace' })
end


lsp_settings()

require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = {
		'bashls',
		'clangd',
		'gopls',
		'html',
		'lua_ls',
	}
})

-- Uncomment if you want setups to be automatic instead of manual
--[[
local get_servers = require('mason-lspconfig').get_installed_servers
for _, server_name in ipairs(get_servers()) do
	lspconfig[server_name].setup({})
end
]]--

lspconfig.bashls.setup({})
lspconfig.clangd.setup({})
lspconfig.gopls.setup({})
lspconfig.html.setup({})

local lua_ls_runtime_path = vim.split(package.path, ';')
table.insert(lua_ls_runtime_path, 'lua/?.lua')
table.insert(lua_ls_runtime_path, 'lua/?/init.lua')

-- (Optional) Configure lua language server for neovim
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				path = lua_ls_runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					-- Make the server aware of Neovim runtime files
					vim.fn.expand('$VIMRUNTIME/lua'),
					vim.fn.stdpath('config') .. '/lua',
				},
			},
		},
	},
})

---
-- Autocompletion
---

local cmp = require('cmp')
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
	},
	mapping = {
		-- confirm selection
		['<C-y>'] = cmp.mapping.confirm({ select = true }),

		-- cancel completion
		['<C-e>'] = cmp.mapping.abort(),

		-- scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		-- navigate items on the list
		['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
		['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),

		-- if completion menu is visible, go to the previous item
		-- else, trigger completion menu
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),

		-- if completion menu is visible, go to the next item
		-- else, trigger completion menu
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		documentation = {
			max_height = 15,
			max_width = 60,
		}
	},
	formatting = {
		fields = { 'abbr', 'menu', 'kind' },
		format = function(entry, item)
			local short_name = {
				nvim_lsp = 'LSP',
				nvim_lua = 'nvim'
			}

			local menu_name = short_name[entry.source.name] or entry.source.name

			item.menu = string.format('[%s]', menu_name)
			return item
		end,
	},
})

