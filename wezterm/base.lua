local wezterm = require('wezterm')
local config = wezterm.config_builder()
local action = wezterm.action

-- gpu config
-- config.prefer_egl = false
--config.enable_wayland = true;
local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[1]
config.front_end = 'WebGpu'
--config.front_end = 'OpenGL'
--for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
--  if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
--    config.webgpu_preferred_adapter = gpu
--    config.front_end = 'WebGpu'
--    break
--  end
--end
config.webgpu_power_preference = "HighPerformance"

-- config.color_scheme = 'Kimber (base16)'
-- config.color_scheme = 'Blazer (Gogh)'
config.color_scheme = 'Breeze'
-- config.color_scheme = 'Bleh-1 (terminal.sexy)'
-- config.color_scheme = 'Catppuccin Mocha (Gogh)'

-- tab bars
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false

-- window
config.window_decorations = "NONE"
config.window_background_opacity = 0.95
config.window_frame = {
    font_size = 12;
}
config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 5,
}
config.font = wezterm.font 'Maple Mono NL NF CN'
config.adjust_window_size_when_changing_font_size = false
-- if set scroll_bar to true, should set window_padding.right
config.enable_scroll_bar = false

config.leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 }
config.keys = {
  -- This will create a new split and run your default program inside it
  { key = '-', mods = 'ALT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = [[\]], mods = 'ALT', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- { key = [[(]], mods = 'CTRL|SHIFT', action = action.CloseCurrentPane({ confirm = true }) },
  { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
  { key = 'Enter', mods = 'ALT', action = action.SpawnTab("CurrentPaneDomain") },
  { key = 'q', mods = 'ALT', action = action.CloseCurrentTab { confirm = true } },
  { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection("Up") },
  { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection("Down") },
  { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection("Left") },
  { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection("Right") },
  { key = '-', mods = 'CTRL', action = action.DecreaseFontSize },
  { key = '=', mods = 'CTRL', action = action.IncreaseFontSize },
  { key = 'Tab', mods = 'ALT', action = action.ShowTabNavigator },
  { key = 'o', mods = 'ALT', action = action.ActivateLastTab },
}

config.quick_select_patterns = {
  -- match hostname
  "(?<=@)[0-9a-zA-Z\\.-]+",
}

-- multiplexing
config.unix_domains = {
  { name = 'unix' },
}

config.default_gui_startup_args = { 'connect', 'unix' }

return config
