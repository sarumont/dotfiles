local options = {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end

    local map = vim.keymap.set

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gs.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gs.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, opts "git stage hunk")
    map('n', '<leader>hr', gs.reset_hunk, opts "git reset hunk")
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts "git stage hunk")
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts "git reset hunk")
    map('n', '<leader>hS', gs.stage_buffer, opts "git stage buffer")
    map('n', '<leader>hu', gs.undo_stage_hunk, opts "git unstage hunk")
    map('n', '<leader>hR', gs.reset_buffer, opts "git reset buffer")
    map('n', '<leader>hp', gs.preview_hunk, opts "git preview hunk")
    map('n', '<leader>gb', function() gs.blame_line{full=true} end, opts "git blame line")
    map('n', '<leader>tb', gs.toggle_current_line_blame, opts "git toggle current line blame")
    -- map('n', '<leader>hd', gs.diffthis)
    -- map('n', '<leader>hD', function() gs.diffthis('~') end)
    -- map('n', '<leader>td', gs.toggle_deleted)
  end,

  current_line_blame = true,
}
require("gitsigns").setup(options)
