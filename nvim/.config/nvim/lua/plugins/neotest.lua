return {
  { "mfussenegger/nvim-dap" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      -- "nvim-neotest/neotest-go",
      "fredrikaverpil/neotest-golang",
    },
    config = function()
      require("neotest").setup {
        options = {
          warn_test_name_dupes = false,
        },
        adapters = {
          require "neotest-golang" {
            -- Here we can set options for neotest-golang, e.g.
            -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
            dap_go_enabled = true, -- requires leoluz/nvim-dap-go
            runner = "gotestsum",
            go_test_args = {
              "-v",
              "-race",
              "-count=1",
              "-cover",
              -- "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
          },
        },
      }
    end,
  },
  {
    "fredrikaverpil/neotest-golang",
    version = "*", -- Optional, but recommended; track releases
    build = function()
      vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
    end,
  },

  -- {
  --   "nvim-neotest/neotest-go",
  --   ft = "go",
  --   dependencies = "nvim-neotest/neotest",
  --   config = function()
  --     -- get neotest namespace (api call creates or returns namespace)
  --     local neotest_ns = vim.api.nvim_create_namespace "neotest"
  --     vim.diagnostic.config({
  --       virtual_text = {
  --         format = function(diagnostic)
  --           local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
  --           return message
  --         end,
  --       },
  --     }, neotest_ns)
  --     require("neotest").setup {
  --       adapters = {
  --         require "neotest-go",
  --       },
  --     }
  --   end,
  -- },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },
}
