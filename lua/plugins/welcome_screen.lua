return {
	-- dashboard to greet
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Set header
			-- dashboard.section.header.val = {}

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "󰈞  > Find file", ":lua require('fzf-lua').files()<CR>"),
				dashboard.button("r", "  > Recent", ":lua require('fzf-lua').oldfiles()<CR>"),

				dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h<cr>"),
				dashboard.button("q", "󰅚  > Quit NVIM", ":qa<CR>"),
			}

			local fortune = require("alpha.fortune")
			dashboard.section.footer.val = fortune({
				fortune_list = {
					{ "With great power, Comes Great Responsibility!", "", "— 🕷️🧓🏻 Uncle Ben" },
					{ "U GUUD MUUUD!", "", "— 👁️👄👁️ Rakai" },
					{ "Nothing is im-paw-sible 🐾", "", "— 🐕" },
					{ "Facts only, no cap in the chat!", "", "— AMP 🦍" },
					{ "Hold up, let me cook—y’all ain’t ready for this!", "", "— Agent00 🚗" },
					{ "We outside! No days off.", "", "— Fanum 🏙️" },
					{ "Hold on Chat... It's HEAVY!!", "", "— Fanum 🏙️" },
					{ "We move different", "", "— Fanum 🏙️" },
				},
			})

			-- Send config to alpha
			alpha.setup(dashboard.opts)
		end,
	},
}
