local M = {}

function M.load_theme()
	local theme_file = M.config.theme_file
	local theme_map = M.config.theme_map

	if not theme_file or theme_file == "" then
		error("Theme-loader: 'theme_file' must be set in the setup configuration.")
	end
	if not theme_map or type(theme_map) ~= "table" then
		error("Theme-loader: 'theme_map' must be a table mapping theme names to themes or functions.")
	end

	if vim.fn.filereadable(theme_file) == 0 then
		error("Theme-loader: Theme file '" .. theme_file .. "' does not exist.")
	end

	local f = io.open(theme_file, "r")
	if f == nil then
		error("Theme-loader: Theme file '" .. theme_file .. "' does not exist.")
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

-- Function to reload the theme (can be called manually)
function M.reload_theme()
	local ok, err = pcall(M.load_theme)
	if not ok then
		vim.notify("Theme-loader error: " .. err, vim.log.levels.ERROR)
	end
end

-- Function to set up a watcher for the theme file
function M.watch_theme_file()
	if not M.config.theme_file then
		return
	end

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = M.config.theme_file,
		callback = function()
			M.reload_theme()
		end,
	})

	-- vim.notify("Theme-loader: Watching for changes in " .. M.config.theme_file)
end

-- Setup function to accept user config
function M.setup(user_config)
	M.config = user_config or {}
	if not M.config.theme_file then
		error("Theme-loader: 'theme_file' must be set in the setup configuration.")
	end

	if not M.config.theme_map then
		error("Theme-loader: 'theme_map' must be set in the setup configuration.")
	end

	-- Optional file watcher
	if M.config.watch_file then
		M.watch_theme_file()
	end

	-- Initial theme load
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			M.load_theme()
		end,
	})
end

return M
