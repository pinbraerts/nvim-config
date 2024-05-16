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

local web = {
	'javascript', 'html', 'css',
}

local shell = {
	'sh', 'ps1',
}

local debug = {
	'python',
	'c', 'cpp', 'rust', 'go',
}

local tex = {
	'tex', 'plaintex', 'bib',
}

local config = {
	'json', 'toml', 'xml', 'zathurarc', 'ini',
}

local documentation = {
	'jsdoc', 'luadoc', 'vimdoc',
}

local lsp = join {
	{ 'lua', 'fastbuild', },
	shell,
	debug,
	web,
	tex,
}

local highlight = join {
	{ 'jq', 'query', },
	{ 'markdown', 'markdown_inline', },
	documentation,
	config,
	lsp,
}

local colorize = join {
	{ 'lua', },
	web,
	config,
	shell,
}

return {
	colorize = colorize,
	lsp = lsp,
	highlight = highlight,
	documentation = documentation,
	config = config,
	tex = tex,
	debug = debug,
	web = web,
	shell = shell,
}
