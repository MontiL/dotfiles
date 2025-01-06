-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font('JetBrainsMono NFM')
config.font_size = 16

config.color_scheme = 'nord'

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE | RESIZE"
config.window_padding = {
  left = 7,
  right = 7,
  top = 10,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
