return{

  {
    "NvChad/nvim-colorizer.lua",
    commit = "f134063618a65cad4d7415fddbd96ff7e0c5b4ae",
    opts = {
      filetypes = {
        "*",
        cmp_docs = { always_update = true },
        cmp_menu = { always_update = true },
      },
      user_default_options = {
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        tailwind = true,
        RGB = true,
        RRGGBB = true,
        AARRGGBB = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        sass = { enable = true, parsers = { "css" } },
        mode = "background", -- Available methods are false / true / "normal" / "lsp" / "both"
        virtualtext = "■",
        always_update = true,
      },
    },
  },
    
}