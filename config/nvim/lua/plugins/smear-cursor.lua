return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- Smear cursor when switching buffers or windows
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,

		-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
		-- Smears will blend better on all backgrounds.
		legacy_computing_symbols_support = false,

		-- Attempt to hide the real cursor when smearing
		hide_target_hack = true,

		-- Minimum time (in ms) between smear updates
		stiffness = 0.8,
		trailing_stiffness = 0.5,
		trailing_exponent = 0.1,

		-- How fast the smear's head moves towards the target
		gamma = 0.8,

		-- Controls the smear's color blending
		distance_stop_animating = 0.5,
		hide_target_hack = true,
	},
}
