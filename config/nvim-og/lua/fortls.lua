-- Require LSP config which we can use to attach gopls
  lspconfig = require "lspconfig"
  util = require "lspconfig/util"
-- Since we installed lspconfig and imported it, we can reach
-- gopls by lspconfig.gopls
-- we can then set it up using the setup and insert the needed configurations
lspconfig.fortls.setup{
    filetypes = {"f90", "F90"},
    cmd = {
        'fortls',
        '--lowercase_intrisics',
        '--hover_signature',
        '--hover_language=fortran',
        '--use_signature_help'
    }
}
