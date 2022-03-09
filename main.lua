package.path = "./?.lua;" .. package.path
math.randomseed(os.time())
local evenchur = require('evenchur')
local success, readline = pcall(require, 'readline')
if success then
	print('(Using readline)')
	readline.set_readline_name('evenchur')
	local words = {}
	for cmd, _ in pairs(evenchur.commands) do
		table.insert(words, cmd)
	end
	for iname, _ in pairs(evenchur.game.objects) do
		table.insert(words, iname)
	end
	for _, dirname in pairs(evenchur.link_alias) do
		table.insert(words, dirname)
	end
	for prep, _ in pairs(evenchur.prepositions) do
		table.insert(words, prep)
	end
	readline.set_complete_list(words)
	function prompt(x)
		return readline.readline(x)
	end
else
	print('(Not using readline)')
	function prompt(x)
		io.write(x)
		return io.read()
	end
end

while true do
	print(evenchur.print_status())
	local line = prompt(evenchur.colors.prompt .. evenchur.state.mode .. "> ")
	if line == nil then
		print('\x1b[1;37;41mIn a rare turn of events, your sword decides to fall on you. Better luck next time!\x1b[m')
		break
	end
	line = line:gsub("\n", "")
	print(evenchur.colors.reset .. evenchur.exec(line:gsub("\n", "")))
	local res = evenchur.game.post_tick()
	if res then print(res) end
	if evenchur.state.finished ~= nil then
		if type(evenchur.state.finished) == "string" then
			print(evenchur.state.finished)
		else
			print("The game is over. Goodbye!")
		end
		break
	end
end
