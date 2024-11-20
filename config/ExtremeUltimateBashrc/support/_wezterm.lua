-- ===========================================================================
-- Wez's Terminal Emulator Settings
-- ---------------------------------------------------------------------------
-- GPU-accelerated cross-platform terminal and multiplexer written in Rust
-- https://wezfurlong.org/wezterm/config/files.html
-- https://github.com/wez/wezterm
-- ===========================================================================

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local mux = wezterm.mux
local act = wezterm.action

-- This table will hold the configuration
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- ===========================================================================
-- This is where you actually apply your config choices
-- ===========================================================================

-- Maximize the window on startup
-- Uses cmd for additional startup command-line arguments if provided
--wezterm.on("gui-startup", function(cmd)
--	local tab, pane, window = mux.spawn_window(cmd or {})
--	window:gui_window():maximize()
--end)

-- Set initial window size in terms of character cells
config.initial_cols = 155  -- Number of columns (width) 148/150/155
config.initial_rows = 40   -- Number of rows (height) 35/42/45

-- Set the default terminal font size
config.font_size = 12

-- Adjust this value to increase or decrease line spacing
config.line_height = 1.0
--config.line_height = 0.8

-- Change the font size of the Command Palette
config.command_palette_font_size = 11.5

-- Set the background opacity of the window
--config.window_background_opacity = 1.0
--config.window_background_opacity = 0.78
config.window_background_opacity = 0.80
--config.window_background_opacity = 0.96

-- Set the background opacity of text to 1.0 (fully opaque)
config.text_background_opacity = 1.0

-- Set a background image
--config.window_background_image = '/home/jeff/.local/share/wallpapers/Custom/Abstract/Dark Black Pattern.jpg'

config.window_background_image_hsb = {
	-- Darken the background image - the lower the number, the darker
	brightness = 1.0,

	-- You can adjust the hue by scaling its value
	-- a multiplier of 1.0 leaves the value unchanged
	hue = 1.0,

	-- You can adjust the saturation also
	saturation = 1.0,
}

-- Specify parameters to influence the font selection
-- Font weight options are "ExtraLight", "Light", "DemiLight",
--   "Regular", "DemiBold", "Bold", "Medium", and "Black"
-- Use a nerd font: https://www.nerdfonts.com/font-downloads
--	weight = 'DemiLight',
--	italic = false
--})
--config.font = wezterm.font('CartographCF Nerd Font', {
--config.font = wezterm.font('Cascursive Nerd Font', {
config.font = wezterm.font('Cascadia Code PL', {
--config.font = wezterm.font('CaskaydiaCovePL Nerd Font', {
--config.font = wezterm.font('CasmataPro Nerd Font', {
--config.font = wezterm.font('CodeliaLigatures Nerd Font', {
--config.font = wezterm.font('DankMono Nerd Font', {
--config.font = wezterm.font('Exosevka Nerd Font', {
--config.font = wezterm.font('FantasqueSansM Nerd Font', {
--config.font = wezterm.font('FiraCode Nerd Font', {
--config.font = wezterm.font('Hacked Nerd Font', {
--config.font = wezterm.font('iMWritingMono Nerd Font', {
--config.font = wezterm.font('InputMono Nerd Font', {
--config.font = wezterm.font('IosevkaCustom Nerd Font', {
--config.font = wezterm.font('JetBrainsMono Nerd Font', {
--config.font = wezterm.font('JuliaMono Nerd Font', {
--config.font = wezterm.font('Lilex Nerd Font', {
--config.font = wezterm.font('M+CodeLat Nerd Font', {
--config.font = wezterm.font('Monoid Nerd Font', {
--config.font = wezterm.font('MonoLisa Nerd Font', {
--config.font = wezterm.font('Mononoki Nerd Font', {
--config.font = wezterm.font('PragmataProMonoLiga Nerd Font', {
--config.font = wezterm.font('SpaceMono Nerd Font', {
--config.font = wezterm.font('Sudo Nerd Font', {
--config.font = wezterm.font('VictorMono Nerd Font', {
--	weight = 'DemiBold',
	weight = 'DemiLight',
--	weight = 'Light',
--	weight = 'Regular',
	italic = false
})

config.font_rules = {
	-- Specify a different terminal font for italics
	{
		italic = true,
		font = wezterm.font("CartographCF Nerd Font", {
--		font = wezterm.font("VictorMono Nerd Font", {
		weight = 'Regular',
--		weight = 'DemiBold',
		italic = true
		}),
	},
}

-- Do not show alerts for missing Font glyphs
-- May appear if text has CJK (Chinese, Japanese, Korean) characters
warn_about_missing_glyphs = false

-- Enable visual bell: Flashes the screen instead of playing a sound
config.visual_bell = {
	-- Duration to fade out the visual bell effect (in milliseconds)
	fade_out_duration_ms = 50,
	-- Duration to fade in the visual bell effect (in milliseconds)
	fade_in_duration_ms = 50,
	-- Target of the visual bell effect (BackgroundColor, ForegroundColor)
	target = "BackgroundColor",
}

-- Set the default window padding
config.window_padding = {
	left = 1,
	right = 10,
	top = 1,
	bottom = 1,
}

-- How many lines of scrollback to keep
config.scrollback_lines = 100000

-- Enable the scrollbar
-- It will occupy the right window padding space
-- If right padding is set to 0 then it will be increased
-- to a single cell width
config.enable_scroll_bar = true

-- Scroll to Bottom on Input
config.scroll_to_bottom_on_input = true

-- Set window decorations to only show resize controls
-- "NONE" - Disables all window decorations, offering a clean, borderless window
-- "RESIZE" - Enables only the resize controls allowing you to change window size
-- "TITLE" - Shows only the title bar omitting other decorations like borders and buttons
-- "TITLE|RESIZE" - Enables resize controls and the title bar, excluding window buttons
config.window_decorations = "TITLE|RESIZE"

-- Set the cursor to a blinking bar
config.default_cursor_style = "BlinkingBar"

-- Cursor Blink Rate (in miliseconds)
config.cursor_blink_rate = 500

-- Easily see which pane you're currently on when you switch between them
config.inactive_pane_hsb = {
	brightness = 0.7,
	saturation = 1.0,
}

-- Enable ligatures
config.harfbuzz_features = {
	-- Enable 'calt' Contextual Alternates
	-- Adjusts the appearance of letters based on their context
	'calt = 1',
	-- Enable 'clig' Contextual Ligatures
	-- Adjusts the way ligatures are displayed based on their context
	'clig = 1',
	-- Enable 'liga' Standard Ligatures
	-- Replaces specific sequences of characters with a single ligature glyph
	'liga = 1'
}

-- This option allows you to specify how text is rendered. For the best subpixel
-- rendering, which is typically used for LCD screens. The available options are:
-- "Normal": Default hinting algorithm, optimized for standard gray-level rendering
-- "Light": A lighter hinting algorithm for non-monochrome modes
-- "Mono": Strong hinting algorithm for monochrome output
-- "HorizontalLcd": Subpixel-rendering variant of Normal, optimized for horizontally decimated LCD displays
config.freetype_load_target = "Normal"

-- ===========================================================================
-- Tab Bar
-- ===========================================================================

-- Show the tab bar
config.enable_tab_bar = true

-- Hide the tab bar if onle one tab exists
config.hide_tab_bar_if_only_one_tab = true

-- Use a styled, fancy version of the tab bar
config.use_fancy_tab_bar = true

-- Show the position number on the left most part of each tab
config.show_tab_index_in_tab_bar = true

-- Set the position of the tab bar
config.tab_bar_at_bottom = false

-- Function to decode URL-encoded strings
function urlDecode(url)
	-- Check if the URL is nil to prevent errors
	if url == nil then
		return nil
	end
	-- Decode the URL encoded text
	url = url:gsub("^file://", "")           -- Remove 'file://' prefix
	url = url:gsub('+', ' ')                 -- Replace '+' with space
		:gsub('%%(%x%x)', function(hex)   -- Find percent-encoded patterns
				return string.char(tonumber(hex, 16)) -- Convert hex to chars
		end)
	return url                               -- Return the decoded URL
end

-- This OPTIONAL event listener is triggered for custom formatting the tab title
-- It's called whenever WezTerm needs to update or recompute the title of a tab
wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)

		-- Accessing the active pane's details from the tab object
		local pane = tab.active_pane

		-- Extracting just the process name from the full path
		-- Pattern '([^/]+)$' captures the last part of the path (process name)
		local process_name = pane.foreground_process_name:match("([^/]+)$")

		-- OPTIONAL if using Extreme Ultimate .bashrc
		-- https://sourceforge.net/projects/ultimate-bashrc/files/
		-- If the process is 'micro', return nil to keep the default title
		if process_name == "micro" then
			return nil
		end

		-- Getting the full directory path and removing 'file://' prefix if present
		-- and decode URL entities like '%20' into their corresponding characters
		local dir = urlDecode(pane.current_working_dir)

		-- Replacing the home directory path with '~'
		local home_dir = os.getenv("HOME")
		if home_dir then
			dir = dir:gsub("^" .. home_dir, "~")
		end

		-- Include the tab index at the beginning of the title
		local tab_number = tab.tab_index + 1 -- tab_index is 0-based

		-- Set and format the tab text
		local title
		if tab.is_active then
			-- Formatting the titel display for the active tab
			--title = "[ " .. tab_number .. ": " .. process_name .. " → " .. dir .. " ]"
			title = " " .. tab_number .. ": " .. process_name .. " → " .. dir
		else
			-- Formatting the title dislay for the inactive tab
			title = " " .. tab_number .. ": " .. process_name .. " → " .. dir
		end

		-- Return the title (indent just a tiny bit to center it better)
		return {
			{ Text = title },
		}
	end
)

-- Configuration options for the main window frame
config.window_frame = {
	-- The font used in the tab bar
	-- Roboto Bold is the default (bundled with wezterm)
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there
	font = wezterm.font {
		family = 'Fira Sans',
		weight = 'DemiBold',
	},

	-- The size of the font in the tab bar
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 11.0,

	-- Background color of the tab bar
	active_titlebar_bg = '#2a2a2a',   -- When window is focused
	inactive_titlebar_bg = '#181818', -- Window is not focused
}

-- Enable automatic hyperlinking of URLs
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ===========================================================================
-- Theme Customization - disabled for custom theme below
-- ---------------------------------------------------------------------------
-- For example, changing the color scheme:
-- https://wezfurlong.org/wezterm/colorschemes/index.html
-- config.color_scheme = 'Tomorrow Night'
-- ===========================================================================

-- Set application colors
config.colors = {
	-- Customize the colors of the tabs
	tab_bar = {
		-- Settings for the active tab (the tab currently in focus)
		active_tab = {
			bg_color = "#424242", -- Sets the background color of the active tab
			fg_color = "#f0f0e0", -- Sets the text color of the active tab
		},

		-- Settings for inactive tabs (tabs that are not in focus)
		inactive_tab = {
			bg_color = "#242424", -- Sets the background color of inactive tabs
			fg_color = "#777777", -- Sets the text color of inactive tabs
		},
	},

	-- The default text color
	foreground = "#CFD8D3",

	-- The default background color
	background = "#181818",

	-- Overrides the cell background color when the current cell is
	-- occupied by the cursor and the cursor style is set to Block
	cursor_bg = "#00FF00",
	cursor_border = "#00FF00",

	-- The color of the scrollbar "thumb"
	-- THis is the portion that represents the current viewport
	scrollbar_thumb = "#2a2a2a",

	-- The color of the split lines between panes
	split = "#444444",

	-- Set the main color theme for the terminal
	ansi = {
		"#545454", -- Black (0)
		"#FD5F6F", -- Red (1)
		"#9FD656", -- Green (2)
		"#F7BE13", -- Yellow (3)
		"#59A1FF", -- Blue (4)
		"#C891FF", -- Magenta (5)
		"#0ED9D2", -- Cyan (6)
		"#CFD8D3"  -- White (7)
	},
	brights = {
		"#5D5D5D", -- Bright Black (8)
		"#FD7688", -- Bright Red (9)
		"#89FF52", -- Bright Green (10)
		"#FFD437", -- Bright Yellow (11)
		"#26B3FF", -- Bright Blue (12)
		"#E69BFF", -- Bright Magenta (13)
		"#0FF5ED", -- Bright Cyan (14)
		"#FFFFFF"  -- Bright White (15)
	},

	-- Color of the cursor foreground when the cursor style is set to Block
	cursor_fg = "#181818",
}

-- ===========================================================================
-- Edit Current Viewport's Text
-- ===========================================================================

wezterm.on('edit-visible-text', function(window, pane)
	-- Note: You could also pass an optional number of lines (eg: 2000) to
	-- retrieve that number of lines starting from the bottom of the viewport
	local viewport_text = pane:get_lines_as_text()

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, 'w+')
	f:write(viewport_text)
	f:flush()
	f:close()

	-- Open a new window running and tell it to open the file
	window:perform_action(
		act.SplitHorizontal {
			args = { 'micro', name },
			--args = { 'ne', name },
			--args = { 'helix', name },
			--args = { 'tilde', name },
			--args = { 'nano', name },
			--args = { 'nvim', name },
			--args = { 'vim', name },
			--args = { 'emacs', name },
		},
		pane
	)

	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt; running
	-- this script and are not awaitable, so we just pick a number
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)

end)

-- ===========================================================================
-- Custom Bindings
-- ===========================================================================

config.mouse_bindings = {
	-- Your mouse bindings go here...
}

config.keys = {
	-- Bind 'CTRL+Tab' to switch to the next tab
	-- This binding activates the next tab relative to the current tab
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action{ActivateTabRelative = 1}
	},

	-- Bind 'CTRL+SHIFT+Tab' to switch to the previous tab
	-- This binding activates the previous tab relative to the current tab
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = wezterm.action{ActivateTabRelative = -1}
	},

	-- Bind 'CTRL+ALT+Number' to move tab to specific positions
	-- This binding shifts the position of the current tab
	{key="1", mods="CTRL|ALT", action=wezterm.action{MoveTab=0}},
	{key="2", mods="CTRL|ALT", action=wezterm.action{MoveTab=1}},
	{key="3", mods="CTRL|ALT", action=wezterm.action{MoveTab=2}},
	{key="4", mods="CTRL|ALT", action=wezterm.action{MoveTab=3}},
	{key="5", mods="CTRL|ALT", action=wezterm.action{MoveTab=4}},
	{key="6", mods="CTRL|ALT", action=wezterm.action{MoveTab=5}},
	{key="7", mods="CTRL|ALT", action=wezterm.action{MoveTab=6}},
	{key="8", mods="CTRL|ALT", action=wezterm.action{MoveTab=7}},
	{key="9", mods="CTRL|ALT", action=wezterm.action{MoveTab=8}},
	{key="0", mods="CTRL|ALT", action=wezterm.action{MoveTab=9}},

	-- Split the window vertically (left and right panes)
	-- CTRL+ALT+\ to split up and down
	{
		key = "\\",
		mods = "CTRL|ALT",
		action = wezterm.action{SplitHorizontal = { domain = "CurrentPaneDomain" }}
	},

	-- Split the window horizontally (top and bottom panes)
	-- CTRL+ALT+- to split side to side
	{
		key = "-",
		mods = "CTRL|ALT",
		action = wezterm.action{SplitVertical = { domain = "CurrentPaneDomain" }}
	},

	-- Split the pane to the right with 'SHIFT+CTRL+ALT+RightArrow'
	{
		key = "RightArrow",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitPane({ direction = "Right" })
	},

	-- Split the pane downward with 'SHIFT+CTRL+ALT+DownArrow'
	{
		key = "DownArrow",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitPane({ direction = "Down" })
	},

	-- Split the pane to the left with 'SHIFT+CTRL+ALT+LeftArrow'
	{
		key = "LeftArrow",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitPane({ direction = "Left" })
	},

	-- Split the pane upward with 'SHIFT+CTRL+ALT+UpArrow'
	{
		key = "UpArrow",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitPane({ direction = "Up" })
	},

	-- Toggle pane zoom state with 'CTRL+F11'
	{
		key = "F11",
		mods = "CTRL",
		action = "TogglePaneZoomState" -- Toggles the zoom state of the current pane
	},

	-- Close the current pane with 'CTRL+ALT+q' without confirmation
	{
		key = "q",
		mods = "CTRL|ALT",
		action = wezterm.action({ CloseCurrentPane = { confirm = false } })
	},

	-- Show launcher with 'CTRL|ALT+l' using fuzzy search for items
	{
		key = "l",
		mods = "CTRL|ALT",
		action = wezterm.action({ ShowLauncherArgs = { flags = "FUZZY|LAUNCH_MENU_ITEMS", title = "Launch" } })
	},

	-- Show workspaces with 'ALT+w'
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action({
			ShowLauncherArgs = { flags = "WORKSPACES", title = "Workspaces" }
		})
	},

	-- Emit custom event 'edit-visible-text' with 'CTRL+SHIFT+e'
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = act.EmitEvent('edit-visible-text')
	},
}

-- Disable the dead keys functionality, which is normally used for typing
-- accented characters. With this setting, pressing a dead key immediately
-- inputs that symbol instead of waiting to combine it with the next keystroke
-- This is useful for users who prefer direct input of these characters,
-- particularly where combining characters are not needed like programming
-- These keys can cause some problems in Vim editors and specific shell hotkeys
use_dead_keys = false

-- ===========================================================================
-- Launch Menu Commands
-- ===========================================================================

config.launch_menu = {
	{
		-- Optional label to show in the launcher. If omitted, a label
		-- is derived from the `args`
		label = 'Bash',
		-- The argument array to spawn. If omitted the default program
		-- will be used as described in the documentation above
		args = { '/usr/bin/bash', '-l' },

		-- You can specify an alternative current working directory;
		-- if you don't specify one then a default based on the OSC 7
		-- escape sequence will be used (see the Shell Integration
		-- docs), falling back to the home directory
		-- cwd = "/some/path"

		-- You can override environment variables just for this command
		-- by setting this here. It has the same semantics as the main
		-- set_environment_variables configuration option described above
		-- set_environment_variables = { FOO = "bar" },
	},
	{
		label = 'Fish',
		args = { '/usr/bin/fish' },
	},
	{
		label = 'Oil Shell',
		args = { '/usr/bin/osh' },
	},
	{
		label = 'Zsh',
		args = { '/usr/bin/zsh' },
	},
	{
		label = 'Top',
		args = { 'top' },
	},
	{
		label = 'Htop',
		args = { '/usr/bin/htop' },
	},
	{
		label = 'Btop',
		args = { '/usr/bin/btop' },
	},
}

-- ===========================================================================
-- and finally, return the configuration to wezterm
-- ===========================================================================
return config
