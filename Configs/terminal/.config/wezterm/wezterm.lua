local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	default_prog = { "/usr/bin/zsh" },
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	warn_about_missing_glyphs = false,
	adjust_window_size_when_changing_font_size = false,
	window_decorations = "RESIZE",
	check_for_updates = true,
	color_scheme = "Catppuccin Macchiato",
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	font_size = 12,
	font = wezterm.font("Cascadia Code"),
	enable_tab_bar = false,
	window_padding = {
		left = 3,
		right = 3,
		top = 0,
		bottom = 0,
	},
	background = {
		{
			source = {
				File = os.getenv("HOME") .. "/.background.png",
			},
		},
	},
}

return config
