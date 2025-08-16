return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- CORE SOURCES (keep these)
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "onsails/lspkind-nvim" },

			-- OPTIONAL: Command line completion
			{ "hrsh7th/cmp-cmdline" },

			-- OPTIONAL: Math & Symbols (uncomment what you want)
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-emoji" },
			{ "kdheepak/cmp-latex-symbols" },

			-- OPTIONAL: Text & Writing (uncomment what you want)
			{ "f3fora/cmp-spell" },
			-- { "uga-rosa/cmp-dictionary" },
			-- { "octaltree/cmp-look" },

			-- OPTIONAL: Academic & Research (uncomment what you want)
			{ "jc-doyle/cmp-pandoc-references" },
			-- { "jalvesaq/cmp-zotero" },

			-- OPTIONAL: Programming (uncomment what you want)
			{ "ray-x/cmp-treesitter" },
			{ "hrsh7th/cmp-nvim-lua" },
			-- { "petertriho/cmp-git" },
			-- { "David-Kunz/cmp-npm" },
			-- { "KadoBOT/cmp-plugins" },

			-- OPTIONAL: AI Completions (uncomment what you want)
			{ "zbirenbaum/copilot-cmp" }, -- Requires copilot.lua setup
			-- { "tzachar/cmp-tabnine", build = "./install.sh" },

			-- OPTIONAL: Database (uncomment if you need SQL completion)
			{ "kristijanhusak/vim-dadbod-completion" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			lspkind.init()

			cmp.setup({
				completion = {
					autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
					completeopt = "menu,menuone,noselect,preview",
				},
				preselect = cmp.PreselectMode.Item,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<S-Down>"] = cmp.mapping.scroll_docs(4),
					["<S-Up>"] = cmp.mapping.scroll_docs(-4),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Replace,
								select = true,
							})
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Esc>"] = cmp.mapping.abort(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							-- Core sources
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
							cmdline = "[Cmd]",

							-- Optional sources (only shown if enabled)
							treesitter = "[TS]",
							spell = "[Spell]",
							dictionary = "[Dict]",
							look = "[Look]",
							calc = "[Calc]",
							emoji = "[Emoji]",
							latex_symbols = "[LaTeX]",
							pandoc_references = "[Ref]",
							zotero = "[Zot]",
							copilot = "[Copilot]",
							cmp_tabnine = "[TabNine]",
							git = "[Git]",
							npm = "[NPM]",
							plugins = "[Plug]",
							vim_dadbod_completion = "[DB]",
						},
					}),
				},
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
						scrollbar = true,
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						max_height = 15,
						max_width = 80,
					}),
				},

				-- DEFAULT SOURCES - Edit this list to add/remove sources
				sources = cmp.config.sources({
					-- Core programming sources
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "treesitter", priority = 700 },

					-- Text sources
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },

					-- Optional sources (add/remove as needed)
					{ name = "calc", priority = 200 },
					{
						name = "emoji",
						priority = 100,
						trigger_characters = { ":" },
						option = {
							insert = true, -- Insert the actual emoji, not just the name
						},
					},

					-- AI sources (uncomment if you want them)
					{ name = "copilot", priority = 1050 },
					-- { name = "cmp_tabnine", priority = 1050 },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- COMMAND LINE COMPLETION (optional - comment out if you don't want it)
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})

			-- FILETYPE-SPECIFIC SOURCES - Customize these based on your needs

			-- Quarto/Markdown (for academic writing)
			cmp.setup.filetype({ "quarto", "markdown", "rmd" }, {
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "latex_symbols", priority = 800 }, -- LaTeX symbols
					{ name = "pandoc_references", priority = 700 }, -- Citations
					{ name = "spell", priority = 600 }, -- Spell check
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
					{
						name = "emoji",
						priority = 100,
						trigger_characters = { ":" },
						option = { insert = true },
					},
					{ name = "calc", priority = 90 },

					-- Add these if you uncommented them in dependencies:
					-- { name = "zotero", priority = 650 },
					-- { name = "dictionary", priority = 550 },
				}),
			})

			-- Lua files (Neovim configuration)
			cmp.setup.filetype("lua", {
				sources = cmp.config.sources({
					{ name = "nvim_lua", priority = 1100 }, -- Neovim Lua API
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
					{ name = "emoji", priority = 100, trigger_characters = { ":" }, option = { insert = true } },

					-- Add this if you uncommented it:
					-- { name = "plugins", priority = 600 },
				}),
			})

			-- Git commit messages (if you uncommented cmp-git)
			-- cmp.setup.filetype("gitcommit", {
			-- 	sources = cmp.config.sources({
			-- 		{ name = "git", priority = 1000 },
			-- 		{ name = "spell", priority = 800 },
			-- 		{ name = "buffer", priority = 500 },
			-- 	}),
			-- })

			-- SQL files (if you uncommented vim-dadbod-completion)
			cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
				sources = cmp.config.sources({
					{ name = "vim_dadbod_completion", priority = 1000 },
					{ name = "nvim_lsp", priority = 800 },
					{ name = "buffer", priority = 500 },
				}),
			})

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Git setup (uncomment if you enabled cmp-git)
			-- require("cmp_git").setup()

			-- Integration with autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	},
}
