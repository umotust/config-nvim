---@diagnostic disable: undefined-global
local files = require("overseer.files")

return {
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.cmd("wincmd L")
      vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.5))
    end,
  }),

  generator = function(_, cb)
    local file = vim.fn.expand("%:p")
    local ft = vim.bo.filetype

    if ft == "markdown" and vim.fn.exists(":MarkdownPreview") == 2 then
      vim.cmd("MarkdownPreview")
      cb({})
      return
    end

    if ft == "python" and vim.fn.exists(":CellRun") == 2 then
      vim.cmd("CellRun")
      cb({})
      return
    end

    local cmds = {
      c = { "bash", "-c", "gcc " .. file .. " -o /tmp/a.out && /tmp/a.out" },
      cpp = { "bash", "-c", "g++ " .. file .. " -o /tmp/a.out && /tmp/a.out" },
      lua = { "lua", file },
      python = { "python", file },
      sh = { "bash", file },

    }

    local cmd = cmds[ft]
    if not cmd then
      vim.notify("No quickrun command for filetype: " .. ft, vim.log.levels.WARN)
      cb({})
      return
    end

    cb({
      {
        name = "quickrun_" .. ft,
        builder = function()
          return {
            cmd = cmd,
            components = {
              { "on_output_quickfix", open = true },
              "default",
            },
          }
        end,
      },
    })
  end,
}
