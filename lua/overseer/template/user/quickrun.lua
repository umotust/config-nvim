---@diagnostic disable: undefined-global
local files = require("overseer.files")

return {
  generator = function(_, cb)
    local file = vim.fn.expand("%:p")
    local ft = vim.bo.filetype
    local cmds = {
      python = { "python3", file },
      sh = { "bash", file },
      lua = { "lua", file },
      cpp = { "bash", "-c", "g++ " .. file .. " -o /tmp/a.out && /tmp/a.out" },
      c = { "bash", "-c", "gcc " .. file .. " -o /tmp/a.out && /tmp/a.out" },
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
