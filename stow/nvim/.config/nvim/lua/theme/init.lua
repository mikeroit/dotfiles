
-- stow/nvim/.config/nvim/lua/theme/init.lua
--
-- The "base" half of the theme split (parallels kitty-base.conf /
-- style-base.css / theme-base.rasi) — but since nvim colorschemes are code,
-- not a flat config, "base" means "the function that maps color *roles*
-- onto nvim highlight groups", and "theme" means "the hex table for those
-- roles" (palette-soft.lua / palette-contrast.lua, built next).

-- Reads the same mode file gen-theme.sh reads/writes
-- ($REPO_DIR/theme-mode, containing just "soft" or "contrast"), so nvim's
-- startup theme always agrees with whatever kitty/waybar/rofi last had.
-- Falls back to "soft" if the file is missing/unreadable rather than
-- erroring — a fresh clone or an edge case shouldn't leave nvim colorless.
local function read_mode()
  local mode_file = vim.fn.expand("~/.dotfiles/theme-mode")
  local f = io.open(mode_file, "r")
  if not f then
    return "soft"
  end
  local mode = f:read("l")
  f:close()
  mode = mode and mode:gsub("%s+$", "") -- strip trailing newline
  if mode == "soft" or mode == "contrast" then
    return mode
  end
  return "soft"
end

local M = {}

function M.apply(palette)
  -- Wipe any previously-loaded colorscheme's highlights before applying
  -- ours, so switching modes at runtime doesn't leave stale groups behind.
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.background = "dark"
  -- Purely cosmetic — lets `:colorscheme` and error messages report a real
  -- name instead of "unknown" if something goes looking for it.
  vim.g.colors_name = "custom-" .. (palette.name or "theme")

  local hl = vim.api.nvim_set_hl

  -- Editor chrome ----------------------------------------------------
  hl(0, "Normal",       { fg = palette.fg, bg = palette.bg })
  hl(0, "NormalFloat",  { fg = palette.fg, bg = palette.bg_alt }) -- floating windows (hover docs, etc.)
  hl(0, "CursorLine",   { bg = palette.bg_alt })
  hl(0, "CursorLineNr", { fg = palette.selected, bold = true })
  hl(0, "LineNr",       { fg = palette.comment })                -- relativenumber column uses this too
  hl(0, "Visual",       { bg = palette.selection_bg, fg = palette.selection_fg })
  hl(0, "Search",       { bg = palette.selected, fg = palette.bg })
  hl(0, "IncSearch",    { bg = palette.active, fg = palette.bg })
  hl(0, "Pmenu",        { fg = palette.fg, bg = palette.bg_alt })  -- completion menu (blink.cmp draws through this)
  hl(0, "PmenuSel",     { fg = palette.bg, bg = palette.selected })
  hl(0, "StatusLine",   { fg = palette.fg, bg = palette.bg_alt })
  hl(0, "WinSeparator", { fg = palette.bg_alt })                  -- vertical split lines

  -- Syntax -------------------------------------------------------------
  hl(0, "Comment",    { fg = palette.comment, italic = true })
  hl(0, "String",     { fg = palette.green })
  hl(0, "Number",     { fg = palette.peach })
  hl(0, "Function",   { fg = palette.blue })
  hl(0, "Keyword",    { fg = palette.magenta })
  hl(0, "Type",       { fg = palette.yellow })
  hl(0, "Identifier", { fg = palette.fg })
  hl(0, "Constant",   { fg = palette.peach })
  hl(0, "PreProc",    { fg = palette.magenta })   -- Rust macros/attributes, C #define, etc.
  hl(0, "Special",    { fg = palette.cyan })
  hl(0, "Delimiter",  { fg = palette.fg })

  -- LSP diagnostics ------------------------------------------------------
  hl(0, "DiagnosticError", { fg = palette.red })
  hl(0, "DiagnosticWarn",  { fg = palette.yellow })
  hl(0, "DiagnosticInfo",  { fg = palette.blue })
  hl(0, "DiagnosticHint",  { fg = palette.cyan })

  -- gitsigns -------------------------------------------------------------
  hl(0, "GitSignsAdd",    { fg = palette.green })
  hl(0, "GitSignsChange", { fg = palette.yellow })
  hl(0, "GitSignsDelete", { fg = palette.red })

  -- (continuing stow/nvim/.config/nvim/lua/theme/init.lua, inside M.apply)

  -- Treesitter-specific overrides ---------------------------------------
  -- These are more specific than the vanilla vim syntax groups above and
  -- take priority over them when treesitter highlighting is active
  -- (which it is — nvim-treesitter is already in init.lua).
  hl(0, "@variable",           { fg = palette.fg })
  hl(0, "@variable.parameter", { fg = palette.fg, italic = true })   -- fn args
  hl(0, "@variable.builtin",   { fg = palette.red })                -- self, Self
  hl(0, "@constant.builtin",   { fg = palette.peach })               -- true, false, None
  hl(0, "@module",             { fg = palette.yellow })              -- module paths: std::, crate::
  hl(0, "@property",           { fg = palette.blue })                 -- struct field access
  hl(0, "@constructor",        { fg = palette.yellow })               -- Struct { .. } / enum variant construction
  hl(0, "@attribute",          { fg = palette.cyan, italic = true })  -- #[derive(...)], #[test]
  hl(0, "@keyword.import",     { fg = palette.magenta })              -- use, mod
  hl(0, "@operator",           { fg = palette.cyan })

  -- LSP semantic tokens — this is where rust-analyzer's own understanding
  -- of your code (not just treesitter's syntax parse) comes through. These
  -- groups only light up with a live rust-analyzer attached, so most of
  -- their payoff is Rust-specific even though the groups aren't Rust-only
  -- by name.
  hl(0, "@lsp.type.lifetime",       { fg = palette.red, italic = true })   -- 'a, 'static
  hl(0, "@lsp.type.unsafe",         { fg = palette.red, bold = true })     -- unsafe blocks/fns — you WANT this to jump out
  hl(0, "@lsp.type.macro",          { fg = palette.magenta, bold = true }) -- println!, vec!, custom macros
  hl(0, "@lsp.type.trait",          { fg = palette.cyan, italic = true })

  hl(0, "@lsp.type.enumMember",     { fg = palette.peach })
  hl(0, "@lsp.type.selfKeyword",    { fg = palette.red })
  hl(0, "@lsp.typemod.function.unsafe",   { fg = palette.red, bold = true })  -- calling an unsafe fn from safe code
  hl(0, "@lsp.typemod.variable.mutable",  { underline = true })              -- mut bindings — visually flag mutation
  hl(0, "@lsp.mod.unsafe",          { fg = palette.red })                    -- catch-all unsafe modifier some servers emit

  -- Inlay hints (type hints / parameter hints) — you already have these
  -- enabled in init.lua's rust-analyzer settings, so they need explicit
  -- styling or they'll default to a jarring/inherited color.
  hl(0, "LspInlayHint", { fg = palette.comment, bg = palette.bg_alt, italic = true })
end

function M.load()
  local mode = read_mode()
  local palette = require("theme.palette-" .. mode)
  M.apply(palette)
end

return M

