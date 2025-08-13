return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-emoji" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "f3fora/cmp-spell" },
			{ "ray-x/cmp-treesitter" },
			{ "kdheepak/cmp-latex-symbols" },
			{ "jc-doyle/cmp-pandoc-references" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "onsails/lspkind-nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			lspkind.init()

			-- Auto popup like Colab
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
					-- Navigation keys
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					--["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					--["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

					-- Scrolling in documentation
					["<S-Down>"] = cmp.mapping.scroll_docs(4),
					--["<CR>"] = cmp.mapping.scroll_docs(4),
					["<S-Up>"] = cmp.mapping.scroll_docs(-4),

					-- PyCharm-like behavior
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

					-- Enter to accept
					-- ["<CR>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() and cmp.get_active_entry() then
					-- 		cmp.confirm({
					-- 			behavior = cmp.ConfirmBehavior.Replace,
					-- 			select = true,
					-- 		})
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),

					-- Escape to close
					["<Esc>"] = cmp.mapping.abort(),

					-- Alternative accept with Ctrl+Space (PyCharm style)
					--["<C-Space>"] = cmp.mapping.complete(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							otter = "[🦦]",

							luasnip = "[snip]",

							nvim_lsp = "[LSP]",

							buffer = "[buf]",

							path = "[path]",

							spell = "[spell]",

							pandoc_references = "[ref]",

							tags = "[tag]",

							treesitter = "[TS]",

							calc = "[calc]",

							latex_symbols = "[tex]",

							emoji = "[emoji]",
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
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
					{ name = "emoji", priority = 100 },
				}),
				experimental = {
					ghost_text = true, -- Shows preview of completion
				},
			})

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

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
