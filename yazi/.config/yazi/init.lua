-- ~/.config/yazi/init.lua
-- Keep zoxide db in sync when moving in Yazi

local ok, zoxide = pcall(require, "zoxide")
if ok then
	zoxide:setup({
		update_db = true,
	})
end
