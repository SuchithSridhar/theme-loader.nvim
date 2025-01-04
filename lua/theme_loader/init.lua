local loader = require("theme_loader.loader")
local watcher = require("theme_loader.watcher")

local M = {}

-- Setup function that lazy.nvim calls
function M.setup(user_config)
	local config = user_config or {}
	if not config.theme_file then
		error("Theme-loader: 'theme_file' must be set in the setup configuration.")
	end

	if not config.theme_map then
		error("Theme-loader: 'theme_map' must be set in the setup configuration.")
	end

	-- Initialize loader with config
	loader.setup(config)

	-- Optional file watcher
	if config.watch_file then
		watcher.watch(config.theme_file, loader.reload_theme)
	end

	-- Lazy-load theme after the event "VeryLazy"
	loader.load_theme()
end

return M
