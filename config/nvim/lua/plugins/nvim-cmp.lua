return{

      {
    "hrsh7th/nvim-cmp",
    init = function()
      vim.g.cmp_disabled = true
    end,
    opts = function(_, opts)
      opts.enabled = function()
        -- local context = require("cmp.config.context")
        if vim.g.cmp_disabled == true then
          return false
        end
        -- some other conditions (like not in commments) can go here
        return not disabled
      end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
    keys = {
      {
        "<leader>ua",
        function()
          vim.g.cmp_disabled = not vim.g.cmp_disabled
          local msg = ""
          if vim.g.cmp_disabled == true then
            msg = "Autocompletion (cmp) disabled"
          else
            msg = "Autocompletion (cmp) enabled"
          end
          vim.notify(msg, vim.log.levels.INFO)
        end,
        noremap = true,
        silent = true,
        desc = "toggle autocompletion",
      },
    },
  },
  
}