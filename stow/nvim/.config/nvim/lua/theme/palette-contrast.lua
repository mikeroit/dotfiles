-- stow/nvim/.config/nvim/lua/theme/palette-contrast.lua
--
-- High-contrast palette for bright/outdoor use. Copied verbatim from
-- kitty-theme-contrast.conf / theme-contrast.rasi — same parity rule
-- as the soft palette above.

return {
  name = "contrast",

  fg      = "#ffffff", -- kitty: foreground
  bg      = "#000000", -- kitty: background
  bg_alt  = "#202020", -- rofi:  background-alt
  comment = "#808080", -- kitty: inactive_border / rofi placeholder-color

  selection_fg = "#000000", -- kitty: selection_foreground
  selection_bg = "#ffff00", -- kitty: selection_background

  selected = "#ffffff", -- rofi: selected
  active   = "#33ff33", -- rofi: active == kitty color2
  urgent   = "#ff3333", -- rofi: urgent == kitty color1

  red     = "#ff3333", -- kitty color1
  green   = "#33ff33", -- kitty color2
  yellow  = "#ffff33", -- kitty color3
  blue    = "#5599ff", -- kitty color4
  magenta = "#ff55ff", -- kitty color5
  cyan    = "#33ffff", -- kitty color6
  -- No peach exists in the contrast palette (it's built from pure/
  -- saturated hues only, per the comment in kitty-theme-contrast.conf).
  -- Picked a saturated orange in the same spirit, used only for
  -- Number/Constant — not reused anywhere else so it doesn't quietly
  -- become a second "yellow" in the palette.
  peach   = "#ff9900",
}
