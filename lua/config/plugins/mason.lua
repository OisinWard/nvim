return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()

      -- Manually maintain the list of tools you want to install
      local ensure_installed = {
        -- LSP
        "basedpyright",
        "ruff",
        "lua-language-server", -- Note: this is the Mason package name, not lua_ls
        -- Formatters
        "stylua",
        "sleek",
        -- Other
        "tree-sitter-cli",
      }

      local registry = require("mason-registry")

      -- Get the list of installed package names
      local installed = registry.get_installed_package_names()

      -- Iterate through the list and install missing ones
      for _, pkg_name in ipairs(ensure_installed) do
        if not vim.tbl_contains(installed, pkg_name) then
          -- Use :MasonInstall to trigger installation
          vim.cmd(":MasonInstall " .. pkg_name)
        end
      end
    end,
  },
}
