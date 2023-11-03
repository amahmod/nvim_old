return {
    'ggandor/leap.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
		-- stylua: ignore
		keys = {
			{ 'sj', '<Plug>(leap-forward-to)',  mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
			{ 'sk', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
			{ 'ss', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
		},
    config = true,
}
