local M = {}
local debounce_timer = nil

-- Debounce function to prevent frequent reloads
local function debounce(callback, delay)
	if debounce_timer then
		debounce_timer:stop()
	end

	debounce_timer = vim.loop.new_timer()
	debounce_timer:start(delay, 0, function()
		vim.schedule(function()
			callback() -- Safely execute the callback on the main thread
		end)
		debounce_timer:stop()
		debounce_timer:close()
		debounce_timer = nil
	end)
end

function M.watch(theme_file, callback)
	local has_fwatch, fwatch = pcall(require, "fwatch")
	if not has_fwatch then
		vim.schedule(function()
			vim.notify("Theme-loader: 'fwatch.nvim' is not installed. File watching disabled.", vim.log.levels.WARN)
		end)
		return
	end

	-- Watch for changes using fwatch.nvim
	fwatch.watch(theme_file, {
		on_event = function()
			-- Debounce and schedule the callback function
			debounce(function()
				vim.schedule(function()
					callback() -- Reload theme safely
					vim.schedule(function()
						vim.api.nvim_echo({ { "Theme-loader: theme reloaded.", "None" } }, false, {})
					end)
				end)
			end, 1000) -- 1000ms debounce time
		end,
	})
end

return M
