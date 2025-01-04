local M = {}
local uv = vim.loop
local debounce_timer = nil

-- Debounce function to prevent frequent reloads
local function debounce(callback, delay)
	if debounce_timer then
		debounce_timer:stop()
	end

	debounce_timer = uv.new_timer()
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
	-- Create a file watcher
	local handle = uv.new_fs_event()

	if not handle then
		vim.schedule(function()
			vim.api.nvim_echo(
				{ { "Theme-loader: Failed to create file watcher for " .. theme_file, "ErrorMsg" } },
				false,
				{}
			)
		end)
		return
	end

	local function on_event(err, filename, events)
		if err then
			vim.schedule(function()
				vim.api.nvim_echo({ { "Theme-loader: Error watching file: " .. err, "ErrorMsg" } }, false, {})
			end)
			return
		end

		-- Debounce and only reload when the file changes
		debounce(function()
			callback()
			print("Theme-loader: Theme reloaded due to changes in " .. theme_file)
		end, 1200) -- Wait 1.2 seconds to ensure file writes complete
	end

	-- Start watching the file
	uv.fs_event_start(handle, theme_file, {}, on_event)

	vim.schedule(function()
		print("Theme-loader: Watching for changes in " .. theme_file)
	end)

	-- Return the handle to allow unwatching if necessary
	return handle
end

function M.unwatch(handle)
	if handle then
		uv.fs_event_stop(handle)
		handle:close()
	end
end

return M
