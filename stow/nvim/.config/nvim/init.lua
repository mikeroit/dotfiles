-- Basic settings

require("theme").load()

-- Opens an RPC socket per nvim instance, one per process id, so
-- gen-theme.sh can push a live theme reload into every running nvim —
-- mirrors kitty's `allow_remote_control` + unix socket pattern, but nvim
-- needs one socket *per open instance* rather than one shared socket,
-- since unlike kitty (one process, many windows) each terminal tab/pane
-- is typically its own separate nvim process.
local nvim_socket = "/tmp/nvim-socket-" .. vim.fn.getpid()
if vim.fn.filereadable(nvim_socket) == 0 then
  vim.fn.serverstart(nvim_socket)
end

vim.g.mapleader = " "

vim.keymap.set({ "n", "v", "o" }, ";", ":", { noremap = true })

-- nav between files
vim.keymap.set("n", "<leader>p", "<C-^>", { desc = "Previous file" })
vim.keymap.set("n", "<leader>q", "<cmd>bprevious | bdelete #<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Rust / LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            check = {
              command = "clippy",
            },
            inlayHints = {
              typeHints = { enable = true },
              parameterHints = { enable = true },
            },
          },
        },
      })

      vim.lsp.enable("rust_analyzer")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
        keymap = {
            preset = "default",

            ["<Tab>"] = { "accept", "fallback" },
            ["<CR>"] = { "accept", "fallback" },

            ["<C-j>"] = { "select_next" },
            ["<C-k>"] = { "select_prev" },

            ["<C-Space>"] = { "show" },
        },
    }
  },
      -- Automatically insert matching parentheses, brackets, and quotes
  {
    "nvim-mini/mini.pairs",
    version = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },
    -- Surround
  {
  "nvim-mini/mini.surround",
  version = false,
  config = function()
      require("mini.surround").setup()
  end,
  },
  -- Syntax highlighting
  {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "rust", "lua", "toml" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
  },

  -- File finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
    },
  },

  -- Git gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
})
