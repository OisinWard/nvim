return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("ruff", {
      init_options = {
        settings = {
          lint = { enable = false },
        },
      },
    })

    -- Configure lua_ls for Neovim development
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.enable({ "basedpyright", "ruff", "lua_ls" })

    vim.diagnostic.config({
      underline = false,
      signs = true,
      virtual_text = false,
    })

    -- Python format on save (Ruff LSP)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function(args)
        vim.lsp.buf.format({
          bufnr = args.buf,
          filter = function(c)
            return c.name == "ruff"
          end,
        })
      end,
    })

    -- Lua format on save (StyLua CLI)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.lua",
      callback = function(args)
        local bufnr = args.buf
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local input = table.concat(lines, "\n") .. "\n"
        local output = vim.fn.system({ "stylua", "--indent-type", "Spaces", "--indent-width", "2", "-" }, input)
        if vim.v.shell_error == 0 then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(output, "\n", { trimempty = true }))
        end
      end,
    })

    -- SQL format on save (Sleek CLI)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.sql",
      callback = function(args)
        local bufnr = args.buf
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local input = table.concat(lines, "\n") .. "\n"
        local output = vim.fn.system({ "sleek" }, input)
        if vim.v.shell_error == 0 then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(output, "\n", { trimempty = true }))
        end
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sql",
      callback = function()
        vim.bo.formatprg = "sleek"
      end,
    })
  end,
}
