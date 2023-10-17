return {
    'ggandor/leap.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
		-- stylua: ignore
		keys = {
			{ 'ss', '<Plug>(leap-forward-to)',  mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
			{ 'sS', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
			{ 'SS', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
		},
    config = true,
}
