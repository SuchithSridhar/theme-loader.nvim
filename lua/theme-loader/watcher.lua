local M = {}

function M.watch(theme_file, callback)
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = theme_file,
		callback = function()
			callback()
		end,
	})

	vim.notify("Theme-loader: Watching for changes in " .. theme_file)
end

return M
