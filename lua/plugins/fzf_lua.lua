return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    {"<leader>ff",
      function() require('fzf-lua').files() end,
      desc = "Find files in current directory"
    },
    {"<leader>fg",
      function() require('fzf-lua').live_grep() end,
      desc = "Find by grepping current dir"
    },
    {"<leader>fc",
      function() require('fzf-lua').files({cwd = vim.fn.stdpath("config")}) end,
      desc = "Find in nvim conf dir"
    },
    {"<leader>fb",
      function() require('fzf-lua').builtin() end,
      desc = "Find built in fuzzy finders list"
    },
    {"<leader>fk",
      function() require('fzf-lua').keymaps() end,
      desc = "Find keymaps"
    },
    {"<leader>fw",
      function() require('fzf-lua').grep_cword() end,
      desc = "Find a word, like grep but u could look inside a specific file/dir"
    },
    {"<leader>fd",
      function() require('fzf-lua').diagnostics_document() end,
      desc = "Find diagnostic doc"
    },
    {"<leader>fr",
      function() require('fzf-lua').resume() end,
      desc = "Find resume from last search"
    },
    {"<leader>fh",
      function() require('fzf-lua').helptags() end,
      desc = "Nvim help menu"
    },
    {"<leader><leader>",
      function() require('fzf-lua').buffers() end,
      desc = "Show buffers opened recently"
    },
    {"<leader>/",
      function() require('fzf-lua').lgrep_curbuf() end,
      desc = "Search something in current file"
    }
  },

}

