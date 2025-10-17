-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = "catppuccin"
local env_var_nvim_theme = os.getenv("NVIM_THEME") or default_color_scheme

-- Define a table of theme modules
local themes = {
	catppuccin = "sam.plugins.themes.catppuccin",
	nord = "sam.plugins.themes.nord",
	onedark = "sam.plugins.themes.onedark",
}

-- Load the selected theme
local theme_module = themes[env_var_nvim_theme]
if theme_module then
	return require(theme_module)
else
	-- Fallback to default if theme not found
	return require(themes[default_color_scheme])
end
