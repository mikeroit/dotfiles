-- stow/nvim/.config/nvim/lua/theme/palette-soft.lua
--
-- Catppuccin Mocha — soft/low-contrast palette. Every hex value here is
-- copied verbatim from kitty-theme-soft.conf / theme-soft.rasi, NOT
-- re-derived from a catppuccin.nvim plugin — the whole point is pixel
-- parity with kitty/waybar/rofi, so these three files must never drift
-- apart. If you ever change one, change all three.

return {
  name = "soft",

  -- Core (== kitty foreground/background, theme-soft.rasi background/foreground)
  fg          = "#cdd6f4", -- kitty: foreground
  bg          = "#1e1e2e", -- kitty: background
  bg_alt      = "#313244", -- rofi:  background-alt (kitty has no direct equivalent; Catppuccin "surface0")
  comment     = "#6c7086", -- kitty: inactive_border / rofi placeholder-color (Catppuccin "overlay0")

  selection_fg = "#1e1e2e", -- kitty: selection_foreground
  selection_bg = "#f5e0dc", -- kitty: selection_background

  selected = "#cba6f7", -- rofi: selected (Catppuccin "mauve")
  active   = "#a6e3a1", -- rofi: active   == kitty color2/10 (green)
  urgent   = "#f38ba8", -- rofi: urgent   == kitty color1/9  (red)

  -- Named accents, pulled straight from kitty's 16-color table
  red     = "#f38ba8", -- kitty color1/9
  green   = "#a6e3a1", -- kitty color2/10
  yellow  = "#f9e2af", -- kitty color3/11
  blue    = "#89b4fa", -- kitty color4/12
  magenta = "#f5c2e7", -- kitty color5/13
  cyan    = "#94e2d5", -- kitty color6/14
  -- Not present in kitty's 16-color table (kitty only defines the
  -- standard 16 ANSI slots) — this is standard Catppuccin Mocha "peach",
  -- pulled in only for Number/Constant so Rust numeric literals read
  -- distinctly from strings/enum variants.
  peach   = "#fab387",
}
