local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 30

config.font = wezterm.font {
	family = 'Berkeley Mono',
	weight = 'DemiBold',
}

config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font {
			family = 'Berkeley Mono',
			weight = 'ExtraBold',
		},
	},
	{
		intensity = 'Bold',
		italic = true,
		font = wezterm.font {
			family = 'Berkeley Mono',
			weight = 'ExtraBold',
			style = 'Oblique',
		},
	},
	{
		intensity = 'Normal',
		italic = true,
		font = wezterm.font {
			family = 'Berkeley Mono',
			weight = 'DemiBold',
			style = 'Oblique',
		},
	},
}

config.font_size = 13
config.line_height = 1.08

config.color_scheme = 'Apple System Colors'

config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true

config.scrollback_lines = 100000
config.enable_scroll_bar = false
config.hide_mouse_cursor_when_typing = true
config.adjust_window_size_when_changing_font_size = false

config.keys = {
	{ key = 'Enter', mods = 'CMD',       action = act.ToggleFullScreen },
	{ key = 'd',     mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	{ key = 'd',     mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
	{ key = 'w',     mods = 'CMD',       action = act.CloseCurrentPane { confirm = true } },
	{ key = 'z',     mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },

	{ key = 'h',     mods = 'CMD|ALT',   action = act.ActivatePaneDirection 'Left' },
	{ key = 'j',     mods = 'CMD|ALT',   action = act.ActivatePaneDirection 'Down' },
	{ key = 'k',     mods = 'CMD|ALT',   action = act.ActivatePaneDirection 'Up' },
	{ key = 'l',     mods = 'CMD|ALT',   action = act.ActivatePaneDirection 'Right' },
}

return config
