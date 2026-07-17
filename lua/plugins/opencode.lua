local tokamak_config = vim.json.encode({
  enabled_providers = { "openai", "tokamak" },
  provider = {
    openai = {
      npm = "@ai-sdk/openai",
      name = "OpenAI via Tokamak",
      options = {
        baseURL = "https://api.tokamak.sh/v1/agent-pool/codex-proxy",
        apiKey = "{env:TOKAMAK_API_KEY}",
        headers = {
          Authorization = "Bearer {env:TOKAMAK_API_KEY}",
        },
      },
    },
  },
  plugin = {},
})

local native_config = vim.json.encode({
  enabled_providers = { "openai", "tokamak" },
  disabled_providers = { "openrouter" },
  model = "openai/gpt-5.5",
  plugin = {},
})

local opencode_profiles = {
  tokamak = {
    name = "Tokamak",
    cmd = {
      "env",
      "XDG_DATA_HOME=" .. vim.fn.expand("~/.local/share/tokamak-opencode"),
      "OPENCODE_CONFIG_CONTENT=" .. tokamak_config,
      "tokamak",
      "launch",
      "opencode",
      "--port",
    },
  },
  native = {
    name = "Native OpenAI OAuth",
    cmd = {
      "env",
      "-u",
      "TOKAMAK_API_KEY",
      "-u",
      "OPENAI_API_KEY",
      "-u",
      "ANTHROPIC_API_KEY",
      "-u",
      "OPENROUTER_API_KEY",
      "OPENCODE_CONFIG_CONTENT=" .. native_config,
      "opencode",
      "--port",
    },
  },
}

local opencode_buf = nil
local opencode_win = nil
local opencode_job = nil
local opencode_profile = nil
local pending_profile = nil

local function read_json(path)
  if vim.fn.filereadable(path) == 0 then
    return {}
  end

  local ok, result = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
  return ok and result or {}
end

local function oauth_email(credential)
  if not credential or credential.type ~= "oauth" or not credential.access then
    return nil
  end

  local payload = credential.access:match("^[^.]+%.([^.]+)")
  if not payload then
    return nil
  end

  payload = payload:gsub("-", "+"):gsub("_", "/")
  payload = payload .. string.rep("=", (4 - #payload % 4) % 4)

  local decoded_ok, decoded = pcall(vim.base64.decode, payload)
  if not decoded_ok then
    return nil
  end

  local json_ok, claims = pcall(vim.json.decode, decoded)
  if not json_ok then
    return nil
  end

  local profile = claims["https://api.openai.com/profile"]
  return claims.email or (profile and profile.email)
end

local function profile_label(profile)
  if profile == "tokamak" then
    local config = read_json(vim.fn.expand("~/.tokamak/config.json"))
    return config.email and ("Tokamak (" .. config.email .. ")") or "Tokamak"
  end

  local auth = read_json(vim.fn.stdpath("data") .. "/opencode/auth.json")
  local email = oauth_email(auth.openai)
  local suffix = email or (auth.openai and auth.openai.type == "oauth" and "connected" or "login required")
  return "Native OpenAI OAuth (" .. suffix .. ")"
end

local function disconnect_opencode()
  local ok, server = pcall(require, "opencode.server")
  if ok and server.connected then
    server.connected:disconnect()
  end
end

local function ensure_opencode_win()
  if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
    return
  end

  vim.cmd("botright vsplit")
  opencode_win = vim.api.nvim_get_current_win()
end

local function open_opencode(profile)
  if opencode_job then
    if opencode_profile ~= profile then
      pending_profile = profile
      disconnect_opencode()
      vim.fn.jobstop(opencode_job)
    else
      ensure_opencode_win()
      vim.api.nvim_win_set_buf(opencode_win, opencode_buf)
      vim.cmd("startinsert")
    end
    return
  end

  ensure_opencode_win()

  opencode_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(opencode_win, opencode_buf)
  vim.api.nvim_buf_set_name(opencode_buf, "OpenCode [" .. opencode_profiles[profile].name .. "]")
  opencode_profile = profile

  opencode_job = vim.fn.termopen(opencode_profiles[profile].cmd, {
    cwd = vim.fn.getcwd(),
    on_exit = function(job_id)
      vim.schedule(function()
        if opencode_job ~= job_id then
          return
        end

        local old_buf = opencode_buf
        local next_profile = pending_profile
        opencode_job = nil
        opencode_buf = nil
        opencode_profile = nil
        pending_profile = nil

        if old_buf and vim.api.nvim_buf_is_valid(old_buf) then
          vim.api.nvim_buf_delete(old_buf, { force = true })
        end

        if next_profile then
          open_opencode(next_profile)
        elseif opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
          vim.api.nvim_win_close(opencode_win, true)
          opencode_win = nil
        end
      end)
    end,
  })

  vim.notify("Launching " .. profile_label(profile), vim.log.levels.INFO, { title = "opencode" })
  vim.cmd("startinsert")
end

local function select_opencode_profile()
  local profiles = { "tokamak", "native" }
  vim.ui.select(profiles, {
    prompt = opencode_job and "Switch OpenCode route:" or "Launch OpenCode with:",
    format_item = profile_label,
  }, function(profile)
    if profile then
      open_opencode(profile)
    end
  end)
end

local function toggle_opencode()
  if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
    vim.api.nvim_win_close(opencode_win, true)
    opencode_win = nil
    return
  end

  if opencode_job and opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
    ensure_opencode_win()
    vim.api.nvim_win_set_buf(opencode_win, opencode_buf)
    vim.cmd("startinsert")
  else
    select_opencode_profile()
  end
end

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  init = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          select_opencode_profile()
        end,
      },
    }
  end,
  config = function()
    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ") end,
      { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
      { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", toggle_opencode, { desc = "Toggle opencode" })
    vim.keymap.set({ "n" }, "<leader>op", select_opencode_profile, { desc = "Switch opencode route" })

    vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if opencode_job then
          vim.fn.jobstop(opencode_job)
        end
      end,
    })
  end,
}
