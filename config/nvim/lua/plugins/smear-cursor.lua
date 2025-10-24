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

		-- MORE EXAGGERATED smear with fast head and dramatic trail
		stiffness = 0.9,              -- Higher = faster cursor head movement
		trailing_stiffness = 0.3,     -- Lower = longer, more dramatic trail
		trailing_exponent = 0.5,      -- Higher = more visible trail particles

		-- Add damping for more elastic, overshooting effect
		damping = 0.7,                -- Lower = more elastic/bouncy (default 0.95)

		-- Allow animation over longer distances
		distance_stop_animating = 0.3,

		-- Increase the length of the trail
		max_slope = 0.5,              -- Makes diagonal movements smoother
	},
}
