vim.opt.number = true
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- plugins
require("lazy").setup({

  -- FILE TREE
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        -- Optional: Add these for better experience
        git = { enable = true },
        diagnostics = { enable = true },
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
      vim.keymap.set("n", "<A-e>", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- INDENT GUIDES
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        -- Optional: Show scope (current indent context)
        scope = { enabled = true },
      })
    end,
  },

  -- THEME (good as is)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
	require("catppuccin").setup({
	  flavour = "mocha",
	  transparent_background = true,
	})
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- LUALINE (good as is)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" }
      })
    end,
  },

  -- BUFFERLINE (good as is)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup()
    end,
  },

  -- TELESCOPE (good as is - fixed version)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
    end,
  },

  -- TREESITTER (good as is)
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    vim.treesitter.language.setup = {}
    require("nvim-treesitter").setup({
      ensure_installed = { "lua", "bash", "python", "c", "cpp", "json" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},
  -- GITSIGNS (good as is)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- AUTOPAIRS (good as is)
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- COMMENT.NVIM (good as is)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
})
