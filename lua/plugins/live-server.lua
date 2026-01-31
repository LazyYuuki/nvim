return { -- create live server for quick html demo
  "aurum77/live-server.nvim",
  config = function()
    require("live_server.util").install()
  end,
  opts = {
    cmd = {
      "LiveServer",
      "LiveServerStart",
      "LiveServerStop",
    },
  },
}
