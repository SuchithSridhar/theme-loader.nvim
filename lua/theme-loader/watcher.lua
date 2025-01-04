local M = {}

function M.watch(theme_file, callback)
	local has_fwatch, fwatch = pcall(require, "fwatch")
	if not has_fwatch then
		vim.notify("Theme-loader: 'fwatch.nvim' is not installed. File watching disabled.", vim.log.levels.WARN)
		return
	end

	-- Watch for changes using fwatch.nvim
	fwatch.watch(theme_file, {
		on_event = function()
			callback()
			vim.notify("Theme-loader: Reloaded theme due to changes in " .. theme_file)
		end,
	})

	vim.notify("Theme-loader: Watching for changes in " .. theme_file .. " using fwatch.nvim")
end

return M
