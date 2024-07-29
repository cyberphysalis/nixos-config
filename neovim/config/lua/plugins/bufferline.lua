return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = function ()
    local color = require("catppuccin.palettes").get_palette()
    return {
      --highlights = require("catppuccin.groups.integrations.bufferline").get(),
      highlights = {
        error = {fg = color.red},
        warning = {fg = color.yellow},
      },
      options = {
        themable = true;
        mode = "tabs",
        --style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo Explorer",
            text_align = "left",
            separator = false,
          }
        },
        diagnostics = "nvim_lsp",
        -- args: count, level, diagnostics_dict, context
        diagnostics_indicator = function(_, level, _, _)
            return level:match("error") and "" or (level:match("warning") and "" or "")
         end,
        separator_style = "thick", -- slope
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },
        numbers = "none",
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true;
        show_close_icon = true,
        show_buffer_close_icons = true,
        show_tab_indicators = false,
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
      }
    }
  end
}
