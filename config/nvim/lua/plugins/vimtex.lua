return{

  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

      -- Turn off VimTeX indentation
      vim.g.vimtex_indent_enabled = 0

      -- Disable default mappings; I'll define my own
      vim.g.vimtex_mappings_enabled = 0

      -- Disable insert mode mappings (in favor of a dedicated snippet engine)
      vim.g.vimtex_imaps_enabled = 0

      -- Disable completion
      -- vim.g.vimtex_complete_enabled = 0

      -- Disable syntax conceal
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Default is 500 lines and gave me lags on missed key presses
      vim.g.vimtex_delim_stopline = 50

      -- VimTeX toggle delimeter configuration
      -- vim.g.vimtex_delim_toggle_mod_list = { ['\left', '\right'] , ['\big', '\big'], }

      -- Don't open quickfix for warning messages if no errors are present
      vim.g.vimtex_quickfix_open_on_warning = 0

      -- Disable some compilation warning messages
      vim.g.vimtex_quickfix_ignore_filters = {
        "LaTeX hooks Warning",
        "Underfull \\hbox",
        "Overfull \\hbox",
        -- 'LaTeX Warning: .\+ float specifier changed to',
        'Package siunitx Warning: Detected the "physics-- package:',
        "Package hyperref Warning: Token not allowed in a PDF string",
        "Fatal error occurred, no output PDF file produced!",
      }

      -- if g:os_current == "Linux"
      vim.g.vimtex_view_method = "zathura"
      -- elseif g:os_current == "Darwin"
      --   vim.g.vimtex_view_method = 'skim'
      -- else
      --   echom "Error: LaTeX forward show not supported on this OS"
      -- endif

      -- Don't automatically open PDF viewer after first compilation
      vim.g.vimtex_view_automatic = 0

      -- Disable continuous compilation
      --vim.g.vimtex_compiler_latexmk = {
      --     'build_dir' = '',
      --     'callback' = 1,
      --     'continuous' = 0,
      --     'executable' = 'latexmk',
      --     'hooks' = [],
      --     'options' = [
      --       '-verbose',
      --       '-file-line-error',
      --       '-synctex=1',
      --       '-interaction=nonstopmode',
      --     ],
      --    }
    end,
  },

}