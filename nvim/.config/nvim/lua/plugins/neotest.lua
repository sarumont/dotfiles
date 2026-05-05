return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        dependencies = {
          {
            "leoluz/nvim-dap-go",
            opts = {},
          },
        },
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-golang"] = {
        warn_test_name_dupes = false,
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-cover",
          -- "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }
    end,
    config = function(_, opts)
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function(_, _)
      -- Set nice color highlighting at the stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DapBreakpointColor", linehl = "", numhl = "" })
    end,
  },

  -- DAP UI setup
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
    },
    opts = {},
    config = function(_, opts)
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle {}
        end,
        desc = "[d]ap [u]i",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "[d]ap [e]val",
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
}
