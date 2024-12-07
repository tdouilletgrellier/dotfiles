-- ========================================
-- Lazy.nvim Bootstrap and Configuration
-- ========================================

-- Path to lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.notify("Bootstrapping lazy.nvim. Please wait...")
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- ========================================
-- Lazy.nvim Setup
-- ========================================
require("lazy").setup({
  -- Plugin Specifications
  spec = {
    -- Import LazyVim and its default plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Import optional LazyVim extras here
    -- Examples:
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },

    -- Import/override with your custom plugins
    { import = "plugins" },
  },

  -- Default Plugin Behavior
  defaults = {
    lazy = false,     -- Custom plugins load during startup (set true for lazy-loading)
    version = false,  -- Use the latest plugin commits (recommended)
    -- version = "*",  -- Use latest stable versions (for plugins with semver support)
  },

  -- Install Configuration
  install = {
    colorscheme = { "tokyonight", "habamax" }, -- Default color schemes
  },

  -- Plugin Update Checker
  checker = {
    enabled = true, -- Automatically check for updates
  },

  -- Performance Optimization
  performance = {
    rtp = {
      -- Disable built-in runtime plugins to speed up startup
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
