# LazyYuuki's nvim config

It is minimal, clean, and it just works (for me).

I sort of reduce a lot on autocomplete snippets because well in the age of AI, it rarely got used anymore?

Feel free to use it, but I'm not responsible for any damage. LOL

## OpenCode

[`lua/plugins/opencode.lua`](lua/plugins/opencode.lua) runs OpenCode as a terminal/server in a right-hand split and lets you choose between two routes:

- **Tokamak** runs `tokamak launch opencode --port`, sends OpenAI requests through the Tokamak proxy, and uses an isolated OpenCode data directory at Neovim's data path under `tokamak-opencode/`.
- **Native OpenAI OAuth** runs `opencode --port`, removes API-key environment variables, and uses the normal OpenCode OAuth credentials with `openai/gpt-5.5`.

Both routes inject their configuration at launch through `OPENCODE_CONFIG_CONTENT`. The local `opencode.json` is gitignored and is not the source of truth for this setup.

The route picker shows the associated Tokamak or OpenAI account when available. Switching routes stops and disconnects the current OpenCode process before launching the selected route. Hiding the split leaves the process and conversation running, while exiting Neovim stops it.

| Key | Action |
| --- | --- |
| `<C-.>` | Show or hide OpenCode; select a route if it is not running. |
| `<leader>op` | Launch OpenCode or switch routes. |
| `<C-a>` | Ask OpenCode about the cursor position or visual selection. |
| `<C-x>` | Open the OpenCode action picker. |
| `go{motion}` | Add the selected motion range to the prompt. |
| `goo` | Add the current line to the prompt. |

OpenCode reads referenced files from disk, so save changes before asking about them. `opencode.nvim` automatically reloads edits and handles permission requests inside Neovim.
