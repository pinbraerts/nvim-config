vim.filetype.add {
	extension = {
		zsh = 'sh',
		sh = 'sh',
	},
	filename = {
		['.zshrc'] = 'sh',
		['.zprofile'] = 'sh',
		['.zshenv'] = 'sh',
	},
}

local function join (arrays)
	local result = { }
	for _, a in ipairs(arrays) do
		local result_size = #result
		for j, v in ipairs(a) do
			result[result_size + j] = v
		end
	end
	return result
end

local M = {}

M.web = {
	'javascript', 'html', 'css',
}

M.shell = {
	'sh', 'ps1',
}

M.debug = {
	'python',
	'c', 'cpp', 'rust', 'go',
}

M.tex = {
	'tex', 'plaintex', 'bib',
}

M.config = {
	'json', 'toml', 'xml', 'zathurarc', 'ini',
}

M.documentation = {
	'jsdoc', 'luadoc', 'vimdoc',
}

M.lsp = join {
	{ 'lua', 'fastbuild', },
	M.shell,
	M.debug,
	M.web,
	M.tex,
}

M.markdown = { 'markdown', 'markdown_inline', }

M.highlight = join {
	{ 'jq', 'query', },
	M.markdown,
	M.documentation,
	M.config,
	M.lsp,
}

M.colorize = join {
	{ 'lua', },
	M.web,
	M.config,
	M.shell,
}

M.treesitter = join {
	{ 'lua' },
	{ 'jq', 'query' },
	{ 'bash' },
	M.web,
	M.debug,
	M.markdown,
	M.documentation,
}

M.webdev = join {
	M.web,
	{
		'xml',
		'typescript', 'javascriptreact', 'typescriptreact',
		'svelte', 'vue', 'tsx', 'jsx', 'rescript',
		'php',
		'markdown',
		'astro', 'glimmer', 'handlebars', 'hbs'
	},
}

return M
