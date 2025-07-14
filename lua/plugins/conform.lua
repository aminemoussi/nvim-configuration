return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use both ruff format and ruff import sorting for Python
			python = { "ruff_format", "ruff_organize_imports" },
			go = { "goimports", "gofmt" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettier", stop_after_first = true },
			c = { "clang-format" },
			cpp = { "clang-format" },
			typescript = { "prettier", stop_after_first = true },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 1500, --in case the formatting takes more than 1.5 secs, it'll be aborted
			lsp_fallback = true, --use lsp formatters if no specific formatter is available
		},
		-- Define custom formatters for ruff
		formatters = {
			ruff_format = {
				command = "ruff",
				args = { "format", "--stdin-filename", "$FILENAME", "-" },
				stdin = true,
			},
			ruff_organize_imports = {
				command = "ruff",
				args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
				stdin = true,
			},
		},
	},
}
