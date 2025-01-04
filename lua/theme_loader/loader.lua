local M = {}

local config = {}

-- Setup function to initialize configuration
function M.setup(user_config)
	config = user_config
end

-- Function to load theme
function M.load_theme()
	local theme_file = config.theme_file
	local theme_map = config.theme_map

	if vim.fn.filereadable(theme_file) == 0 then
		error("Theme-loader: Theme file '" .. theme_file .. "' does not exist.")
	end

	local f = io.open(theme_file, "r")
	if not f then
		error("Theme-loader: Cannot open theme file.")
	end
	local theme_name = f:read("*all"):gsub("%s+", "") -- Remove whitespace
	f:close()

	if theme_name == "" then
		error("Theme-loader: Theme file is empty.")
	end

	local theme_to_load = theme_map[theme_name]
	if not theme_to_load then
		error("Theme-loader: No theme found for name '" .. theme_name .. "'. Please update your theme map.")
	end

	if type(theme_to_load) == "string" then
		vim.cmd.colorscheme(theme_to_load)
	elseif type(theme_to_load) == "function" then
		theme_to_load()
	else
		error("Theme-loader: Invalid theme mapping for '" .. theme_name .. "'. Must be a string or function.")
	end
end

-- Function to reload the theme
function M.reload_theme()
	local ok, err = pcall(M.load_theme)
	if not ok then
		vim.notify("Theme-loader error: " .. err, vim.log.levels.ERROR)
	end
end

return M
