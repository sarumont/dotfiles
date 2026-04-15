return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      -- Disable treesitter highlight for html and large files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function(args)
          vim.treesitter.stop(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function(args)
          local max_filesize = 500 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then
            vim.notify(
              "File larger than 500KB, treesitter disabled for performance",
              vim.log.levels.WARN,
              { title = "Treesitter" }
            )
            vim.treesitter.stop(args.buf)
          end
        end,
      })

      require("nvim-treesitter").install {
        -- vim
        "vim",
        "lua",

        -- web
        "html",
        "css",
        "json",
        "javascript",
        "typescript",

        -- markup
        "comment",
        "markdown",
        "markdown_inline",
        "yaml",

        -- real languages
        "go",
        "gomod",
        "gowork",
        "gosum",
        "java",
        "kotlin",
        "cmake",

        -- utils
        "bash",
        "dockerfile",
        "terraform",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup {
        enable = true,
        multiwindow = false,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
        on_attach = nil,
      }
    end,
  },
}
