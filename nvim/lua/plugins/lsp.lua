return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          checkOnSave = false,
          check = {
            allTargets = false,
          },
          files = {
            excludeDirs = {
              "out",
              ".git",
              ".cache",
            },
          },
        },
      },
    },
  },
}
